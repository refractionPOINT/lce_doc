# Exfil

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

Finally, note that Exfil configurations are synchronized with sensors every few minutes.

## Performance Mode
Although not stricly related to Exfil, the sensor's Performance Mode can also be set as a rule, on top of interactively.

This is done by modifying Performance Rules through the web app or REST interface. Any sensor matching a rule will have its performance mode enabled.

## Throughput Limits
Enabling every event for exfil can produce an exceedingly large amount of traffic (think all file io, all network, all registry etc).

Managing this requires a few different mechanisms.

First of all, if you leave the default exfil profiles enabled, you should never have to worry about any of the following.

LimaCharlie attempts to process all events in real-time. When it falls behind, the events get enqueued, up to a certain limit.
If that limit is reached (as in the case of a long, sustained burst, or enabling all event types all the time), the queue 
eventually gets dropped and you may lose events. In that case, an error is emitted to the platform logs.

Seeing those errors should be a sign you need to do one or more of the following:

1. Reduce the events you select.
1. Reduce the number of D&R rules you run or their complexity.
1. Adopt a more selective subset of the events you select by creating Watch Rules that bring back only the events with the specific values you need.
1. Enable the IR mode (more on this below).

Before the queue gets dropped, LimaCharlie attempts to increase performance by entering a special mode we call "afterburner".

This mode tries to address one of the common scenarios that can lead to large influx of data: spammy processes starting over and over again. This
happens most often in situations such as during building of software where, for example, `devenv.exe` or `git.exe` can be called hundreds of times
per second. The afterburner mode attempts to de-duplicate those processes and only process each one once through the D&R rules and Outputs (storage).

The afterburner mode does not address all possible causes or situations, so another tool is available, the "IR mode". This mode is enabled by tagging
a LimaCharlie sensor with the tag `ir`. The goal is to provide a solution for users who want to record a very large number of events, but do not need to
run D&R rules over all of them. When enabled, the "IR mode" will not de-duplicate events, but will only run D&R rules over the following event types:

1. `NEW_PROCESS`
1. `CODE_IDENTITY`
1. `DNS_REQUEST`
1. `NETWORK_CONNECTIONS`

This gives you a balance between recording all events, while maintaining basic D&R rule capabilities.

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