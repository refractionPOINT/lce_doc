# Detection and Response

[TOC]

Detection & Response rules are designed to allow you to push out a detection rule and with a custom action in record time.
Think of them like AWS Lambda or Google Cloud Functions. They can be added and removed with single operations
and they become immediately available/running as they are set.

A D&R rule has two components:

* the detection part of the rule is a simple expression that describes what the rule should match on.
* the response part of the rule describes the list of actions that should be taken when the rule matches.

The REST interface expects those rules in their native JSON format (as described below), but UIs to generate this
format are available if you are uncomfortable with the JSON.

For more sample rules and guidelines around rule writing, see our [public repository dedicated to this purpose](https://github.com/refractionPOINT/rules).

The website version of this (on limacharlie.io) takes the rules as YAML to make them easier to visualize.

## Namespaces
Detection and Response rules support a few namespaces. Initially you do not have to worry about using them since by default
operations on rules use the `general` namespace.

However, if you plan on having multiple groups of people accessing DR rules and want to maintain some segmentation, then
namespaces are for you. An example of this is an MSSP wanting to allow their customers to create their own rules without
giving them access to the MSSP-maintained sets of rules.

Beyond the `general` namespace, the main other namespace is called `managed` (as in MSSP-managed). Currently, operating
on namespaces other than `general` can only be accomplished using the [REST API](api_keys.md) by providing the `namespace`
parameter in the relevant queries.

## Detection Component
The Detection component describes what event(s) should produce a match, which the Response section will then action.

### Targets

Targets are types of sources of events that the rule should apply to. The D&R rules apply by default to the `edr` target.
This means that if you omit the `target` element from the Detection component, the rule will assume you want it to apply
to events coming from the LimaCharlie agents. Other targets are available however.

* `edr`: the default, [telemetry events](events.md#edr-events) from LC agents.
* `log`: applies to external logs submitted through the REST API or through the [log_get](sensor_commands.md#log_get) command of the agent.
* `deployment`: applies to [high level events](events.md#deployment-events) about the entire deployment, like new enrollments and cloned sensors detected.

While the `edr` and `deployment` targets supports most of the APIs, stateful operators and actions below, the `log` target only supports the following subset:

* All the basics: `is`, `and`, `or`, `exists`, `contains`, `starst with`, `ends with`, `is greater than`, `is lower than`, `matches`, `string distance`
* Referring to add-ons / resources: `lookup`, `external`
* Response actions: `report`
* `log` target only: `log source`, `log type`

In the case of the `log` target, `path` references apply to JSON parsed logs the same way as in `edr` DR rules, but rules on pure text logs requires using the
path `/txt` as the value of a log line. The `log source` matches the log's source string, and the `log type` matches the log's type string.

### Basic Structure

Each logical operation in this component is a dictionary with an `op` field. Complex logical evaluation is done
by using two special `op` values, `and` and `or`. These will take a `rules` parameter that is a list of other logical
operations to perform.

Here is a basic example of a rule that says:
When we receive a `STARTING_UP` event from a linux sensor, and this sensor has the tag `test_tag`, match.

```json
{
    "op": "and",
    "rules" : [
        {
            "op": "is linux",
            "event": "STARTING_UP"
        },
        {
            "op" : "is tagged",
            "tag": "test_tag"
        }
    ]
}
```

The `"event": "SOME_EVENT_NAME"` pattern can be used in all logical nodes to filter the type of event being
evaluated. You can also use an `"events": [ "EVENT_ONE", "EVENT_THREE"]` to filter in certain types of events. When a detection is generated (through the `report` action), it gets fed back into D&R rules with an `event_type`
of `_DETECTIONNAME`. This can be used to compose higher order detections.

### Logical Operations
Some parameters are available to all logical operations.

* `"not": true`: will reverse the matching outcome of an operations.
* `"case sensitive": false`: will make all string-based evaluations ignore case.

A recurring parameter also found in many operations is the `"path": <>` parameter. It represents a path within the event
being evaluated that we want the value of. Its structure is very close to a directory structure. It also supports the
`*` wildcard to represent 0 or more directories, and the `?` wildcard which represents exactly one directory.

The root of the path should be `event` or `routing` depending on whether you want to get a value from the event itself or
the routing instead.

Note that many comparison values support a special "lookback" format. That is, an operation that supports comparing
a value to a literal like `"system32"`, can also support a value of `"<<event/PARENT/FILE_PATH>>"`. When that value is
surrounded by `"<<  >>"`, it will be interpreted as a path within the event and the
value at that path will replace the `"<<...>>"` value. This allows you to "look back" at the event and use values
within for your rule.

For example, this sample JSON event:
```json
{
    "USER_ID": 501,
    "PARENT": {
        "USER_ID": 501,
        "COMMAND_LINE": "/Applications/Sublime Text.app/Contents/MacOS/plugin_host 71954",
        "PROCESS_ID": 71955,
        "USER_NAME": "maxime",
        "FILE_PATH": "/Applications/Sublime Text.app/Contents/MacOS/plugin_host",
        "PARENT_PROCESS_ID": 71954,
        "DEEP_HASH": {
            "HASH_VALUE": "ufs8f8hfinsfd9sfdsf"
        }
    },
    "PROCESS_ID": 23819,
    "FILE_PATH": "/Applications/Xcode.app/Contents/Developer/usr/bin/git",
    "PARENT_PROCESS_ID": 71955
}
```

The following paths with their result element:

* `<<event/USER_ID>>` results in `501`
* `<<event/?/USER_NAME>>` results in `"maxime"`
* `<<event/PARENT/PROCESS_ID>>` results in `71955`
* `<<event/*/HASH_VALUE>>` results in `ufs8f8hfinsfd9sfdsf`

#### and, or
The standard logical boolean operations to combine other logical operations. Take a single `"rules" : []` parameter
with the logical operations to apply the boolean logic to.

#### is
Tests for equality between the value of the `"value": <>` parameter and the value found in the event at the `"path": <>`
parameter.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

Example rule:
```json
{
    "op": "is",
    "path": "event/PARENT/PROCESS_ID",
    "value": 9999
}
```

#### exists
Tests if any elements exist at the given path.

Example rule:
```yaml
op: exists
path: event/PARENT
```

#### contains, ends with, starts with
The `contains` checks for a substring match, `starts with` checks for a prefix match and `ends with` checks for a suffix
match.

They all use the `path` and `value` parameters.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

#### is greater than, is lower than
Check to see if a value is greater or lower (numerically) than a value in the event.

They both use the `path` and `value` parameters.
They also both support the `length of` parameter as a boolean (true or false). If set to true, instead of comparing
the value at the specified path, it compares the length of the value at that path.

#### matches
The `matches` op compares the value at `path` with a regular expression supplied in the `re` parameter.
Under the hood, this uses the Python 2.7 `re` module with `findall`, which means the regular expression
is applied to every line of the field (if the field is multi-line), which enables you to apply the regexp
to log files.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

Example:
```json
{
    "op": "matches",
    "path": "event/FILE_PATH",
    "re": ".*\\\\system32\\\\.*\\.scr",
    "case sensitive": false
}
```

#### string distance
The `string distance` op looks up the [Levenshtein Distance](https://en.wikipedia.org/wiki/Levenshtein_distance) between
two strings. In other words it generates the minimum number of character changes required for one string
to become equal to another.

For example, the Levenshtein Distance between `google.com` and `googlr.com` (`r` instead of `e`) is 1.

This can be used to find variations of file names or domain names that could be used for phishing, for example.

Suppose your company is `onephoton.com`, looking for the Levenshtein Distance between all `DOMAIN_NAME` in
`DNS_REQUEST` events, compared to `onephoton.com` could detect an attacker using `onephot0n.com` in a phishing
email domain.

The operator takes a `path` parameter indicating which field to compare, a `max` parameter indicating the
maximum Levenshtein Distance to match and a `value` parameter that is either a string or a list of strings
that represent the value(s) to compare to.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

Example:
```yaml
op: string distance
path: event/DOMAIN_NAME
value:
  - onephoton.com
  - www.onephoton.com
max: 2
```
This would match `onephotom.com` and `0nephotom.com` but NOT `0neph0tom.com`.

and using the [file name](#file-name) transform to apply to a file name in a path:
```yaml
op: string distance
path: event/NEW_PROCESS
file name: true
value:
  - svchost.exe
  - csrss.exe
max: 2
```

This would match `svhost.exe` and `csrss32.exe` but NOT `csrsswin32.exe`.

#### is windows, is linux, is mac, is 32 bit, is 64 bit
All of these operators take no additional arguments, they simply match if the relevant sensor characteristic is
correct.

#### is tagged
Determines if the tag supplied in the `tag` parameter is already associated with the sensor that the event under evaluation
is from.

#### lookup
Looks up a value against a LimaCharlie Resource such as a threat feed. The value is supplied via the `path` parameter and
the resource path is defined in the `resource` parameter. Resources are of the form `lcr://<resource_type>/<resource_name>`.
In order to access a resource you must have subscribed to it via `app.limacharlie.io`.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

Example:
```json
{
    "op": "lookup",
    "path": "event/DOMAIN_NAME",
    "resource": "lcr://lookup/malwaredomains",
    "case sensitive": false
}
```

#### Stateful
The following special operators are known as Stateful operators. In general, each D&R rule is limited to a single Stateful
operator per rule. These operators are special in that they do not operate on a single event received from an agent, but rather
they operate on the entire state of events from an agent, through time.

Concretely what this all means is that they allow you to do things like:

* Detect certain combinations of events through time (e.g. 3 instances of process X within 5 minutes).
* Detect complex relationships between events, such as process ancestry (e.g. if you see cmd.exe as a child N levels deep of a notepad.exe).

Needless to say, these are extremely powerful. But with great capabilities comes great responsibility; using these operators
in a "bad" way will result in very poor performance and possibly your rule being ejected.

Under the hood, these operators use a form of [Finite State Machines](https://en.wikipedia.org/wiki/Finite-state_machine) in order to be able
to perform forward lookup only (no need to do a lookup "backwards" in time in a database). This results in a minimal state of relevant events
being kept in memory for the lifetime of the sensor. A bad rule may result in this minimal state being extremely big, which is undesirable.

Exactly what constitutes good usage and bad usage will be discussed on a per operator basis.

##### process burst
This will detect when a process matching the `re` parameter is created a minimum of `count` times per `time` (seconds) period.

It is important to keep the bounds reasonable. Any process matching `re` will be kept in the state for at least `time` seconds, so having
a `time` that is extremely big will potentially keep more events in state. Therefore, if your `re` is somewhat loose, try to make the `time`
a smaller value to keep less state.

Example (detect at least 4 Linux reconnaissance processes created within 5 seconds):
```json
{
    "op": "process burst",
    "re": ".*/((ifconfig)|(arp)|(route)|(ping)|(traceroute)|(nslookup)|(netstat)|(wget)|(curl))",
    "count": 4,
    "time": 5
}
```

##### process descendant
This will detect a suspicious relationship between a parent process matching the regular expression `parent` and one of the following:

* if `child` is specified, will detect when a descendant process of `parent` matches the regular expression `child`.
* if the `document` is specified, will detect when a process descendant of `parent` creates a [new document](events.md#new_document) with a
file path matching the regular expression in `document`.
* `child event type`: if specified, will detect when a process descendant of `parent` is an event of this type..

In addition to this base behavior, the following modifiers are available:

* `only direct`: if set to `true`, the target relationship will only attempt to detect a direct relationship, meaning if a non-matching process
exists in between the `parent` and `child` (or `document`), no detection will be generated.
* `parent root`: for a match on the `parent` to be made, the parent process must be owned by the `root` user on Linux and MacOS, or by an Administrator
account on Windows.
* `child root`: similar behavior as `parent root` but is applied to the `child`.
* `parent signed`: for a match on the `parent` to be made, the parent process executable must be signed and valid.
* `child signed`: for a match on the `child` to be made, the child process executable must be signed and valid.

This operator potentially keeps a lot more state than others. A process will be kept in state if it matches the `parent` process and this for as long
as the `parent` process stays alive. This means a bad combination for this operator is to have a `parent` that matches very common processes, and for
those processes to have a very long lifetime, and for those `parent` processes to create a lot of child processes. This should be avoided at all costs.

The best combination for this operator is to use a rare `parent`. For example, `notepad.exe` as a `parent` is great, it's not that common and almost never
creates other processes. On the other hand, `explorer.exe` is an awful parent as it creates many processes and stays alive for a very long time.

Example (detects a descendant of notepad.exe creating cmd.exe):
```json
{
    "op": "process descendant",
    "parent": ".*notepad.exe",
    "child": ".*cmd.exe"
}
```

#### VirusTotal
The lookup can also use certain APIs in their lookup, such as VirusTotal. Note that for the VT API to be accessible, the
organization needs to be subscribed to the VT API Add-On, and a valid VT API Key needs to be set in the integrations
configurations.

As shown in the example below, a `metadata_rules` parameter is also valid for the lookup operation. It can contain
further detection rules to be applied to ***the metadata returned by a lookup match***. In the case of VT this is a dictionary
of AntiVirus vendor reports (here we test for more than 1 vendor reporting that the hash is bad), while in the case of a custom
lookup resource it would be whatever is set as the item's metadata.

To activate VirusTotal usage, you must subscibe to the VirusTotal API in the Add-On section. Then you must set your VirusTotal
API key in the Integrations section of the limacharlie.io web interface.

VirusTotal results are cached locally for a limited period of time which reduces the usage of your API key and saves you money.

Also note that if your API Key runs out of quota with VirusTotal, hashes seen until you have quota again will be ignored.

Example:
```yaml
op: lookup
event: CODE_IDENTITY
path: event/HASH
resource: 'lcr://api/vt'
metadata_rules:
  op: is greater than
  value: 1
  path: /
  length of: true
```

#### IP GeoLocation
The lookup can also use certain APIs in their lookup, like IP GeoLocation. Note that for the IP GeoLocation to be accessible, the
organization needs to be subscribed to the `api/ip-geo` API Add-On.

As shown in the example below, a `metadata_rules` parameter is also valid for the lookup operation. It can contain
further detection rules to be applied to ***the metadata returned by a lookup match***. In the case of `ip-geo` this is a dictionary
of the geolocation data returned by the IP GeoLocation data provider, [MaxMind.com](https://maxmind.com).

The format of the metadata returned is documented [here](https://github.com/maxmind/MaxMind-DB-Reader-python) and looks like this:

```json
{
  "country": {
    "geoname_id": 2750405,
    "iso_code": "NL",
    "is_in_european_union": true,
    "names": {
      "ru": "\u041d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u044b",
      "fr": "Pays-Bas",
      "en": "Netherlands",
      "de": "Niederlande",
      "zh-CN": "\u8377\u5170",
      "pt-BR": "Holanda",
      "ja": "\u30aa\u30e9\u30f3\u30c0\u738b\u56fd",
      "es": "Holanda"
    }
  },
  "location": {
    "latitude": 52.3824,
    "accuracy_radius": 100,
    "time_zone": "Europe/Amsterdam",
    "longitude": 4.8995
  },
  "continent": {
    "geoname_id": 6255148,
    "code": "EU",
    "names": {
      "ru": "\u0415\u0432\u0440\u043e\u043f\u0430",
      "fr": "Europe",
      "en": "Europe",
      "de": "Europa",
      "zh-CN": "\u6b27\u6d32",
      "pt-BR": "Europa",
      "ja": "\u30e8\u30fc\u30ed\u30c3\u30d1",
      "es": "Europa"
    }
  },
  "registered_country": {
    "geoname_id": 2750405,
    "iso_code": "NL",
    "is_in_european_union": true,
    "names": {
      "ru": "\u041d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u044b",
      "fr": "Pays-Bas",
      "en": "Netherlands",
      "de": "Niederlande",
      "zh-CN": "\u8377\u5170",
      "pt-BR": "Holanda",
      "ja": "\u30aa\u30e9\u30f3\u30c0\u738b\u56fd",
      "es": "Holanda"
    }
  }
}
```

To activate IP GeoLocation usage, you must subscibe to the `api/ip-geo` API in the Add-On section.

Also note that if your API Key runs out of quota with VirusTotal, hashes seen until you have quota again will be ignored.

Example (is the connecting agent in a European Union country):
```yaml
op: lookup
resource: 'lcr://api/ip-geo'
path: routing/ext_ip
event: CONNECTED
metadata_rules:
  op: is
  value: true
  path: country/is_in_european_union
```

The geolocation data comes from GeoLite2 data created by [MaxMind](http://www.maxmind.com).

#### external
Use an external detection rule loaded from a LimaCharlie Resource. The resource is specified via the `resource` parameter.
Resources are of the form `lcr://<resource_type>/<resource_name>`. The `external` operation only supports Resources of
type `detection`. The external detection replaces the current detection rule, which means it can be combined with other
detection logic using the `and` and `or` operations.

Example:
```json
{
    "op": "external",
    "resource": "lcr://detection/suspicious-windows-exec-location"
}
```

Complex example extending a resource rule:
```yaml
op: and
rules:
  - op: is tagged
    tag: finance-dept
  - op: external
    resource: lcr://detection/suspicious-windows-exec-location
```

### Transforms
Transforms are transformations applied to the value being evaluated in an event, prior to the evaluation.

#### file name
Sample: `file name: true`

The `file name` transform takes a file path and replaces it with the file name component of the path.
This means that the file path `c:\windows\system32\wininet.dll` will become `wininet.dll`.

#### sub domain
Sample: `sub domain: "-2:"`

The `sub domain` extracts specific components from a domain name. The value of `sub domain` is in basic slice notation.
This notation is of the form `startIndex:endIndex` where the index is 0-based and indicates which parts of the domain to keep.
Examples:

  * `0:2` means the first 2 components of the domain: `aa.bb` for `aa.bb.cc.dd`.
  * `-1` means the last component of the domain: `cc` for `aa.bb.cc`.
  * `1:` means all components starting at 1: `bb.cc` for `aa.bb.cc`.
  * `:` means to test the operator to every component individually.

## Response Component
The response component is simpler as it does not have the boolean logic concept. It is simply a list of actions to take
when the Detection component matches.

The action type is specified in the `action` parameter.

### Actions
Possible actions are:

#### task
This action sends the task (as described [here](sensor_commands.md)) in the `command` parameter to the sensor that the event
under evaluation is from. An optional `investigation` parameter can be given, it associates the given
identifier with the task and events from the sensor that relate to the task.

Example:
```json
{
    "action": "task",
    "command": "history_dump",
    "investigation": "susp-process-inv"
}
```

#### report
Reports the match as a detection. This means that the content of this event will be bubbled up to the Detection Output
stream. Think of it as an alert. It takes a `name` parameter that will be used as a detection category and an optional `publish`
parameter that defaults to `true`. If set to `false`, the report won't be published to the Output stream.

This last distinction about the `publish` parameter is important because the detections created by the `report` action
get fed back into the D&R rules so that more complex rules may handle more complex evaluations of those. Setting `publish` to `false` means that this detection is only really used as an intermediary and should not be reported in and
of itself. When fed back, the `event_type` is set to `_DETECTIONNAME`.

Finally, the `priority` parameter is optional. If set, it should be an integer. This integer
will get added to the root of the detection report.

Example:
```yaml
action: report
name: my-detection
priority: 3
```

#### add tag, remove tag
These two actions associate and disassociate, respectively, the tag found in the `tag` parameter with the sensor. The "add tag" operation
can also optionally take a "ttl" parameter that is a number of seconds the tag should remain applied to the agent.

Example:
```json
{
    "action": "add tag",
    "tag": "vip",
    "ttl": 30
}
```

## Putting it Together

Note that through limacharlie.io, in order to provide an easier to edit format, the same rule configuration
is used but is in YAML format instead. For example:
**Detect:**
```yaml
op: ends with
event: NEW_PROCESS
path: event/FILE_PATH
value: .scr
```

**Respond:**
```yaml
- action: report
  name: susp_screensaver
- action: add tag
  tag: uses_screensaver
  ttl: 80000
```

### WanaCry
Simple WanaCry detection and mitigation rule:

**Detect**
```json
{
    "op": "ends with",
    "event": "NEW_PROCESS",
    "path": "event/FILE_PATH",
    "value": "@wanadecryptor@.exe",
    "case sensitive": false
}
```

**Respond**
```json
[
    {
        "action": "report",
        "name": "wanacry"
    },
    {
        "action": "task",
        "command": "history_dump"
    },
    {
        "action": "task",
        "command": [ "deny_tree", "<<routing/this>>" ]
    }
]
```


### Classify Users
Tag any sensor where the CEO logs in with "vip".

**Detect**
```json
{
    "op": "is",
    "event": "USER_OBSERVED",
    "path": "event/USER_NAME",
    "value": "stevejobs",
    "case sensitive": false
}
```

**Respond**
```json
[
    {
        "action": "add tag",
        "tag": "vip"
    }
]
```

### Suspicious Windows Executable Names
```json
{
    "op": "matches",
    "path": "event/FILE_PATH",
    "case sensitive": false,
    "re": ".*((\\.txt)|(\\.doc.?)|(\\.ppt.?)|(\\.xls.?)|(\\.zip)|(\\.rar)|(\\.rtf)|(\\.jpg)|(\\.gif)|(\\.pdf)|(\\.wmi)|(\\.avi)|( {5}.*))\\.exe"
}
```

### Disable an Event at the Source
Turn off the sending of a specific event to the cloud. Useful to limit some verbose data sources when not needed.

**Detect**
```yaml
op: is windows
event: CONNECTED
```

**Respond**
```yaml
- action: task
  command: exfil_del NEW_DOCUMENT
```

### Monitoring Sensitive Directories
Make sure the File Integrity Monitoring of some directories is enabled whenever Windows sensors connect.

**Detection**
```yaml
event: CONNECTED
op: is windows
```

**Respond**
```yaml
- action: task
  command: fim_add --pattern "C:\\\\*\\\\Programs\\\\Startup\\\\*" --pattern "\\\\REGISTRY\\\\*\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run*"
```

### Mention of an Internal Resource
Look for references to private URLs in proxy logs.

**Detection**
```yaml
target: log
op: contains
path: /txt
value: /corp/private/info
```

**Respond**
```yaml
- action: report
  name: web-proxy-private-url
```
