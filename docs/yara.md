# YARA

## Overview
The YARA service is designed to help you with all aspects of YARA scanning. It takes what is normally a manual piecewise process, provides a framework and automates it.

Once configured, YARA scans can be run on demand for a particular endpoint or continuously in the background across your entire fleet.

There are three main sections to the YARA job.

Note that Yara configurations are synchronized with sensors every few minutes.

### Sources
This is where you define the source for your particular YARA rule(s). Source URLs can be either a direct link to a given YARA rule or [ARLs](arl.md)].

An example of setting up a source using this repo: [Yara-Rules](https://github.com/Yara-Rules/rules)

For `Email and General Phishing Exploit` rules we would link the following URL, which is basically just a folder full of .yar files.

[https://github.com/Yara-Rules/rules/tree/master/email](https://github.com/Yara-Rules/rules/tree/master/email)

Giving the source a name and clicking the Add Source button will create the new source.

### Rules
Rules define which sets of sensors should be scanned with which sets of YARA signatures (or sources).

Filter tags are tags that must ALL be present on a sensor for it to match (AND condition), while the platform of the sensor much match one of the platforms in the filter (OR condition).

### Scan
To apply YARA Sources and scan an endpoint you must select the hostname and then add the YARA Sources you would like to run as a comma separated list.

### REST

#### List Sources
```
{
  "action": "list_sources"
}
```

#### List Rules
```
{
  "action": "list_rules"
}
```

#### Add Rule
```
{
  "action": "add_rule",
  "name": "example-rule",
  "sources": [
    "my-source-1",
    "my-source-2",
    "my-source-3"
  ],
  "tags": [
    "vip",
    "workstation"
  ],
  "platforms": [
    "windows",
    "mac"
  ]
}
```

#### Add Source
```
{
  "action": "add_source",
  "name": "example-rule",
  "sources": [
    "my-source-1",
    "my-source-2",
    "my-source-3"
  ],
  "tags": [
    "vip",
    "workstation"
  ],
  "platforms": [
    "windows",
    "mac"
  ]
}
```

#### Remove Rule
```
{
  "action": "remove_rule",
  "name": "example-rule"
}
```

#### Remove Source
```
{
  "action": "remove_source",
  "name": "my-source-1"
}
```

#### Scan
```
{
  "action": "scan",
  "sid": "70b69f23-b889-4f14-a2b5-633f777b0079",
  "sources": [
    "my-source-1",
    "my-source-2"
  ]
}
```