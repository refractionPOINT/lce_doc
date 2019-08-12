# Exfil

[TOC]

## Overview
The Exfil job allows you to customize which events should be sent to the cloud in real-time.
This is done using an Event List which describes specific event types. And using a Watch list which
describes a pattern that when found within a specific event type, will trigger the event to be sent
to the cloud.

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