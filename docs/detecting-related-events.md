# Detecting Related Events

## Overview

> It's recommended to first read [Detection & Response Rules](dr.md) before diving into detecting related events.

Events in LimaCharlie have well-defined relationships to one another using `routing/this`, `routing/parent`, `routing/target`. This can be useful for writing more complex rules that connect different but related events. We call these "stateful" rules. 

## Detecting Children / Descendants

To detect related rules, you can use the following parameters:

* `with child`: matches children of the initial event  
* `with descendant`: matches descendants (children, grandchildren, etc) of the initial event

Aside from how deep they match, the `with child` and `with descendant` parameters operate identically: they create a nested rule context.

For example, let's detect a `cmd.exe` process spawning a `calc.exe` process:

```yaml
# Detect initial event
event: NEW_PROCESS
op: ends with
path: event/FILE_PATH
value: cmd.exe
case sensitive: false
with child: # Wait for child matching this nested rule
  op: ends with
  event: NEW_PROCESS
  path: event/FILE_PATH
  value: calc.exe
  case sensitive: false
```

Simply put, this will detect:

```
cmd.exe --> calc.exe
```

Because it uses `with child` it will not detect:

```
cmd.exe --> firefox.exe --> calc.exe
```

To do that, we could use `with descendant` instead.

## Nested Rules

Rules declared within `with child` and `with descendant` parameters have full range - they can do anything a normal rule might do, including declaring nested `with child` or `with descendant` rules, or using `and`/`or` operators to write complex rules. For example:

```yaml
event: NEW_PROCESS
op: ends with
path: event/FILE_PATH
value: outlook.exe
case sensitive: false
with child:
  op: and
  rules:
    - op: ends with
      event: NEW_PROCESS
      path: event/FILE_PATH
      value: chrome.exe
      case sensitive: false
    - op: ends with
      event: NEW_DOCUMENT
      path: event/FILE_PATH
      value: .ps1
      case sensitive: false
```

The above example is looking for an `outlook.exe` process that spawns a `chrome.exe` process and drops a `.ps1` (powershell) file to disk. Like this:

```
outlook.exe
|--+--> chrome.exe
|--+--> .ps1 file
```

### Counting Events

Rules declared using `with child` or `with descendant` have the ability to count a given number of matching events within a given number of seconds.

For example, a rule that matches on Outlook writing 5 new .ps1 documents within 60 seconds:

```yaml
event: NEW_PROCESS
op: ends with
path: event/FILE_PATH
value: outlook.exe
case sensitive: false
with child:
  op: ends with
  event: NEW_DOCUMENT
  path: event/FILE_PATH
  value: .ps1
  case sensitive: false
  count: 5
  within: 60
```

### Choosing Event to Report

A reported detection will include a copy of the event that was detected. When writing detections that match multiple events, the default behavior will be to include a copy of the initial parent event. 

In many cases it's more desirable to get the latest event in the chain instead. For this, there's a `report latest event: true` flag that can be set. Piggy-backing on the earlier example:

```yaml
# Detection
event: NEW_PROCESS
op: ends with
path: event/FILE_PATH
value: outlook.exe
case sensitive: false
report latest event: true
with child:
  op: and
  rules:
    - op: ends with
      event: NEW_PROCESS
      path: event/FILE_PATH
      value: chrome.exe
      case sensitive: false
    - op: ends with
      event: NEW_DOCUMENT
      path: event/FILE_PATH
      value: .ps1
      case sensitive: false
  
# Response
- action: report
  name: Outlook Spawning Chrome & Powershell
```

The event returned in the detection will be either the `chrome.exe` `NEW_PROCESS` event or the `.ps1` `NEW_DOCUMENT` event, whichever was last. Without `report latest event: true` being set, it would default to including the `outlook.exe` `NEW PROCESS` event.

## Caveats

### Testing Stateful Rules

Stateful rules are forward-looking only and changing a rule wil reset its state. 

Practically speaking, this means that if you change a rule that detects `excel.exe -> cmd.exe`, `excel.exe` will need to be relaunched while the updated rule is running for it to then begin watching for `cmd.exe`. 

### Using Events in Actions

Using `report` to report a detection works according to the [Choosing Event To Report](detecting-related-events.md#choosing-event-to-report) section earlier. Other actions have a subtle difference: they will _always_ observe the latest event in the chain.

Consider the `excel.exe -> cmd.exe` example. The `cmd.exe` event will be referenced inside the response action if using lookbacks (i.e. `<<routing/this>>`). If we wanted to end the `excel.exe` process (and its descendants), we would write a `task` that references the parent of the current event (`cmd.exe`):

```yaml
- action: task
  command: deny_tree <<routing/parent>>
```
