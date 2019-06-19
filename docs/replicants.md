# Replicants

[TOC]

## Overview
Replicants can be thought of as digital automatons: expert driven algorithms which utilize some basic artificial intelligence to perform tasks that would normally be completed by humans.

## Using
Each replicant has a particular specialization and can be enabled in the same manner as any [Add-on](user-addons.md) through the user interface of the web application.

Once enabled the replicant will show up in the War Room which is linked off of the main menu inside of the Organization view of the web application.

## REST API
Replicants can be interacted with using the REST API's `/replicant/{oid}/{replicantName}` endpoint. This endpoint is generic for all Replicants, the actual underlying request
structure is per-Replicant as described below.

## Available Replicants
Below you will find a brief explanation of each available replicant, along with details on the particular configuration requirements.

### YARA
The YARA replicant is designed to help you with all aspects of YARA scanning. It takes what is normally a manual piecewise process, provides a framework and automates it.

Once configured, YARA scans can be run on demand for a particular endpoint or continuously in the background across your entire fleet.

There are three main sections to the YARA replicant.

#### Sources
This is where you define the source for your particular YARA rule(s). Source URLs can be either a direct link to a given YARA rule or links to a Github repository with a collection of signatures in multiple files.

An example of setting up a source using this repo: [Yara-Rules](https://github.com/Yara-Rules/rules)

For `Email and General Phishing Exploit` rules we would link the following URL, which is basically just a folder full of .yar files.

[https://github.com/Yara-Rules/rules/tree/master/email](https://github.com/Yara-Rules/rules/tree/master/email)

Giving the source a name and clicking the Add Source button will create the new source.

#### Rules
Rules define which sets of sensors should be scanned with which sets of YARA signatures (or sources).

Filter tags are tags that must ALL be present on a sensor for it to match (AND condition), while the platform of the sensor much match one of the platforms in the filter (OR condition).

#### Scan
To apply YARA Sources and scan an endpoint you must select the hostname and then add the YARA Sources you would like to run as a comma separated list.

#### REST

##### List Sources
```
{
  "action": "list_sources"
}
```

##### List Rules
```
{
  "action": "list_rules"
}
```

##### Add Rule
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

##### Add Source
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

##### Remove Rule
```
{
  "action": "remove_rule",
  "name": "example-rule"
}
```

##### Remove Source
```
{
  "action": "remove_source",
  "name": "my-source-1"
}
```

##### Scan
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

### Responder
The Responder replicant is able to perform various incident response tasks for you.

#### Sweep
A sweep is an in-depth look through the state of a host. The sweep will highlight parts of the activity that are suspicious. This provides you with a good starting position when beginning an investigation. It allows you to focus on the important things right away.

The types of information returned by the sweep is constantly evolving but you can expect it to return the following information:

* A full list of processes and modules
* A list of unsigned binary code running in processes
* Network connections with a list of processes listening and active on the network
* Hidden modules
* A list of recently modified files
* Unique or rare indicators of compromise

#### REST

##### Sweep
```
{
  "action": "sweep",
  "sid": "70b69f23-b889-4f14-a2b5-633f777b0079"
}
```

### Integrity
Integrity helps you manage all aspects of File and Registry integrity monitoring.

#### Rules
Rules define which file path patterns and registry patterns should be monitored for changes for specific sets of hosts.

Filter tags are tags that must ALL be present on a sensor for it to match (AND condition), while the platform of the sensor much match one of the platforms in the filter (OR condition).

Patterns are file or registry patterns, supporting wildcards (*, ?, +). Windows directory separators (backslash, "\") must be escaped like "\\".

#### Linux
FIM is partially supported on Linux. Specified file path expressions are actively monitored
via inotify (as opposed to MacOS and Windows where kernel passively monitors).

Due to inotify limitations, paths with wildcard are less efficient and only support
monitoring up to 20 sub-directories covered by the wildcard. In addition to this, the
path expressions should specify a final wildcard of `*` when all files under a directory
need to be monitored. Ommiting this `*` will result in only the directory itself being
monitored.

#### REST

##### List Rules
```
{
  "action": "list_rules"
}
```

##### Add Rule
```
{
  "action": "add_rule",
  "name": "linux-root-ssh-configs",
  "patterns": [
    "/root/.ssh/*"
  ],
  "tags": [
    "vip",
    "workstation"
  ],
  "platforms": [
    "linux"
  ]
}
```

##### Remove Rule
```
{
  "action": "remove_rule",
  "name": "linux-ssh-configs"
}
```

### Logging
Logging helps you specify external log files you want automatically ingested through
the LC sensor. File expressions specified are monitored at recurring interval for changes
and when a change is detected, the file gets pushed to the [External Logs](external_logs.md)
API where it gets indexed for various IOCs and available for visualization.

***Important Note*** that this process is aimed at log files that rotate at recurring interval and not files
that are continuously streamed to. So for example specifying the file `/var/log/syslog` is a bad
idea since it will likely mean the same log file will be pushed over and over again (since new
log lines are added continuously). Instead, target `/var/log/syslog.1` which is the file where
the `syslog` file gets rotated to daily since this provides you with cleaner logs that are
not duplicated.

#### REST

##### List Rules
```
{
  "action": "list_rules"
}
```

##### Add Rule
```
{
  "action": "add_rule",
  "name": "linux-servers-syslog",
  "patterns": [
    "/var/log/syslog.1"
  ],
  "tags": [
    "server"
  ],
  "platforms": [
    "linux"
  ],
  "is_delete_after": false
}
```

##### Remove Rule
```
{
  "action": "remove_rule",
  "name": "linux-servers-syslog"
}
```

### Replay
Replay allows you to run [replay](replay.md) jobs in a managed way without using the REST interface or CLI yourself.

#### REST

##### Replay Job
```
{
  "action": "replay",
  "start": 1560960433,
  "end": 1560962433,

  // Optional sensor to use as event source, whole organization if not specified.
  "sid": "70b69f23-b889-4f14-a2b5-633f777b0079",

  // Optional D&R rule name that exists in organization to apply.
  "rule_name": "win-suspicious-exec-location",

  // Optional rule content to apply.
  "rule_content": {
    "detect": {
      "op": "is",
      ...
    },
    "respond": [
      "task": "report",
      "name": "exec-loc-found"
    ]
  }

  // One of rule_name or rule_content must be specified.
}
```
