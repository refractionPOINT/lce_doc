# Template Strings and Transforms

Many areas of LimaCharlie support template strings and transforms.

A template string allows you to customize the value of a configuration based on the context. For example to adjust the Detection Name in a D&R rule to include a value from the detection itself.

A transform allows you to change the shape of JSON data in flight to suit better your usage. This can mean moving, renaming, removing and adding fields in JSON. For example, it can allow you to create an Output that works with `DNS_REQUEST` events, but outputs only specific fields from the event.

## Template Strings

Template strings in LimaCharlie use the format defined by "text templates" found [here](https://pkg.go.dev/text/template). A useful guide provided by Hashicorp is also available [here](https://learn.hashicorp.com/tutorials/nomad/go-template-syntax).

The most basic example for a D&R rule customizing the detection name looks like this:
```yaml
- action: report
  name: Evil executable on {{ .routing.hostname }}
```

Template strings also support some LimaCharlie-specific functions:
* `token`: applies an MD5 hashing function on the value provided.
* `anon`: applies an MD5 hashing function on a secret seed value, plus the value provided.

The `token` and `anon` functions can be used to partially anonymize data anywhere a template string is supported, for example:
```yaml
- action: report
  name: 'User {{token .event.USER_NAME }} accessed a website against policy.'
```

## Transforms

With Transforms, you specify a JSON object that describes the transformation.

This object is in the shape of the final JSON you would like to transform to.

Key names are the literal key names in the output. Values support one of 3 types:

1. Template Strings, as described above. In this case, the template string will be generated and placed at the same place as the key in the transform object.
1. A `gjson` selector. The selector syntaxt is defined [here](https://github.com/tidwall/gjson/blob/master/SYNTAX.md). It makes it possible to select subsets of input object and map it within the resulting object as defined by the transform.
1. Other JSON objects which will be present in the output.

Let's look at an example, let's say this is the Input to our transform:

```json
{
    "event": {
        "EVENT": {
            "EventData": {
                "AuthenticationPackageName": "NTLM",
                "FailureReason":             "%%2313",
                "IpAddress":                 "34.64.101.177",
                "IpPort":                    "0",
                "KeyLength":                 "0",
                "LmPackageName":             "-",
                "LogonProcessName":          "NtLmSsp",
                "LogonType":                 "3",
                "ProcessId":                 "0x0",
                "ProcessName":               "-",
                "Status":                    "0xc000006d",
                "SubStatus":                 "0xc0000064",
                "SubjectDomainName":         "-",
                "SubjectLogonId":            "0x0",
                "SubjectUserName":           "-",
                "SubjectUserSid":            "S-1-0-0",
                "TargetDomainName":          "",
                "TargetUserName":            "ADMINISTRADOR",
                "TargetUserSid":             "S-1-0-0",
                "TransmittedServices":       "-",
                "WorkstationName":           "-",
            },
            "System": {
                "Channel":  "Security",
                "Computer": "demo-win-2016",
                "Correlation": {
                    "ActivityID": "{F207C050-075F-0001-AFE1-ED1F3897D801}",
                },
                "EventID":       "4625",
                "EventRecordID": "2832700",
                "Execution": {
                    "ProcessID": "572",
                    "ThreadID":  "2352",
                },
                "Keywords": "0x8010000000000000",
                "Level":    "0",
                "Opcode":   "0",
                "Provider": {
                    "Guid": "{54849625-5478-4994-A5BA-3E3B0328C30D}",
                    "Name": "Microsoft-Windows-Security-Auditing",
                },
                "Security": "",
                "Task":     "12544",
                "TimeCreated": {
                    "SystemTime": "2022-07-15T22:48:24.996361600Z",
                },
                "Version": "0",
            },
        },
    },
    "routing": {
        "arch":       2,
        "did":        "b97e9d00-ca17-4afe-a9cf-27c3468d5901",
        "event_id":   "f24679e5-5484-4ca1-bee2-bfa09a5ba3db",
        "event_time": 1657925305984,
        "event_type": "WEL",
        "ext_ip":     "35.184.178.65",
        "hostname":   "demo-win-2016.c.lc-demo-infra.internal",
        "iid":        "7d23bee6-aaaa-aaaa-aaaa-c8e8cca132a1",
        "int_ip":     "10.128.0.2",
        "moduleid":   2,
        "oid":        "8cbe27f4-aaaa-aaaa-aaaa-138cd51389cd",
        "plat":       268435456,
        "sid":        "bb4b30af-ff11-4ff4-836f-f014ada33345",
        "tags": [
            "edr",
            "lc:stable",
        ],
        "this": "c5e16360c71baf3492f2dcd962d1eeb9",
    },
    "ts": "2022-07-15 22:48:25",
}
```

And this is our Transform definition:

```json
{
    "message": "Interesting event from {{ .routing.hostname }}",  // a format string
    "from":    "{{ \"limacharlie\" }}",                           // a format string with only a literal value
    "dat": {                                                      // define a sub-object in the output
        "raw": "event.EVENT.EventData",                           // a "raw" key where we map a specific object from the input
    },
    "anon_ip": "{{anon .routing.int_ip }}",                       // an anonymized version of the internal IP
    "ts":   "routing.event_time",                                 // map a specific simple value
    "nope": "does.not.exist",                                     // map a value that is not present
}
```

Then the resulting Output would be:

```json
{
    "dat": {
        "raw": {
            "AuthenticationPackageName": "NTLM",
            "FailureReason": "%%2313",
            "IpAddress": "34.64.101.177",
            "IpPort": "0",
            "KeyLength": "0",
            "LmPackageName": "-",
            "LogonProcessName": "NtLmSsp",
            "LogonType": "3",
            "ProcessId": "0x0",
            "ProcessName": "-",
            "Status": "0xc000006d",
            "SubStatus": "0xc0000064",
            "SubjectDomainName": "-",
            "SubjectLogonId": "0x0",
            "SubjectUserName": "-",
            "SubjectUserSid": "S-1-0-0",
            "TargetDomainName": "",
            "TargetUserName": "ADMINISTRADOR",
            "TargetUserSid": "S-1-0-0",
            "TransmittedServices": "-",
            "WorkstationName": "-"
        }
    },
    "from": "limacharlie",
    "message": "Interesting event from demo-win-2016.c.lc-demo-infra.internal",
    "nope": null,
    "ts": 1657925305984,
    "anon_ip": "e80b5017098950fc58aad83c8c14978e"
}
```
