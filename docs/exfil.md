# Exfil

[TOC]

## Overview
By default, LimaCharlie sensors send events to the cloud based on a standard profile that includes
events like `NEW_PROCESS`, `DNS_REQUEST` etc.

If you enable the Exfil Service, this default profile is replaced by a custom set of rules you define.

The rule customization is done in two parts:

1. The Event Rules, which simply define a list of events that should be sent to the cloud based on platform and tags.
1. The Watch Rules, which define additional events that should be sent to the cloud based on the content of each individual event.

The Watch Rules allow you to specify a platform and tag to select which sensors the rule applies to, plus these elements:

* Event: the specific event type that should be evaluated, like `MODULE_LOAD`.
* Path: the path within the `event` component whose value should be evaluated, like `FILE_PATH`.
* Operator: the type of evaluation/comparison that should be done between the value at Path in the event and the Value.
* Value: the value used in the comparison.

For example:
```
Event: MODULE_LOAD
Path: FILE_PATH
Operator: ends with
Value: wininet.dll
```

The above rule would tell the sensor to send to the cloud, in real-time, all `MODULE_LOAD` events where the `FILE_PATH` ends with the value `wininet.dll`.

## Performance Mode
Although not stricly related to Exfil, the sensor's Performance Mode can also be set as a rule on top of interactively.

This is done by modifying Performance Rules through the web app or REST interface. Any sensor matching a rule will have its performance mode enabled.

### REST

#### List Rules
```
{
  "action": "list_rules"
}
```

#### Add Event Rule
```
{
  "action": "add_event_rule",
  "name": "windows-vip",
  "events": [
    "NEW_TCP4_CONNECTION",
    "NEW_TCP6_CONNECTION"
  ],
  "tags": [
    "vip"
  ],
  "platforms": [
    "windows"
  ]
}
```

#### Remove Event Rule
```
{
  "action": "remove_event_rule",
  "name": "windows-vip"
}
```

#### Add Watch
```
{
  "action": "add_watch",
  "name": "wininet-loading",
  "event": "MODULE_LOAD",
  "operator": "ends with",
  "value": "wininet.dll",
  "path": "FILE_PATH",
  "tags": [
    "server"
  ],
  "platforms": [
    "windows"
  ]
}
```

#### Remove Watch
```
{
  "action": "remove_watch",
  "name": "wininet-loading"
}
```

#### Add Performance Rule
```
{
  "action": "add_perf_rule",
  "name": "sql-servers",
  "tags": [
    "sql"
  ],
  "platforms": [
    "windows"
  ]
}
```

#### Remove Performance Rule
```
{
  "action": "remove_perf_rule",
  "name": "sql-servers"
}
```