# Detection on Alternate Targets

## Overview

Detection & Response rules run against `edr` events by default, but there are 3 other targets:
* `deployment`
* `artifact`
* `artifact_event`

This article is to give some ideas of what they're used for, and how they're used.

## Target: deployment

Deployment events relate to sensors connecting to the cloud: `enrollment`, `sensor_clone`, `sensor_over_quota`, `deleted_sensor`.

Take the `sensor_clone` event as an example. This event can happen when a sensor is installed in a VM image, leading to duplicate sensor IDs connecting to the cloud. When this is detected we can use this event to automate behavior to de-duplicate the sensor. 

The `deployment` target supports all of the same operators (stateful or otherwise) and actions as regular `edr` rules.

### Example

```yaml
# Detection
target: deployment
event: sensor_clone
op: is windows

# Response
- action: task
  command: file_del %windir%\\system32\\hcp.dat
- action: task
  command: file_del %windir%\\system32\\hcp_hbs.dat
- action: task
  command: file_del %windir%\\system32\\hcp_conf.dat
- action: task
  command: restart
```

This rule de-duplicates sensors on Windows by deleting `.dat` files specific to the Windows installation and then issuing a `restart` sensor command. 

> For samples of each `deployment` event type, see [Reference: Events](https://doc.limacharlie.io/docs/documentation/ZG9jOjE5MzExMDQ-events#deployment-events).

## Target: artifact

Parsed artifacts can be run through the rule engine as if they were regular `edr` events, but there are some key differences. Namely, they support a subset of operators and actions, while adding some special parameters.

### Example

This rule will target parsed `/var/log/auth.log` entries to see if there are are auth failures.

```yaml
# Detection
target: artifact
artifact type: txt
artifact path: /var/log/auth.log
op: matches
re: .*(authentication failure|Failed password).*
path: /text
case sensitive: false

# Response
- action: report
  name: Failed Auth
```

### Supported Operators

*  `is`
* `and`
* `or`
* `exists`
* `contains`
* `starts with`
* `ends with`
* `is greater than`
* `is lower than`
* `matches`
* `string distance`

### Supported Resources

`lookup` and `external` resources are supported within rules just like the `edr` target.

### Supported Actions

The only response action supported for the `artifact` target is the `report` action.

### Special Parameters

* `artifact path`: matches the start of the artifact's `path` string, e.g. `/auth.log`
* `artifact type`: matches the artifact's `type` string, e.g. `pcap`, `zeek`, `auth`, `wel`
* `artifact source`: matches the artifact's `source` string, e.g. `hostname-123`

> Note: for duplicate Windows Event Log ingestions, the rule engine will use the log's `EventRecordID` to ensure a rule will not run more than once over the same record. 


## Target: artifact_event 

For unparsed logs, it can be useful to use the `ingest` and `export_complete` lifecycle events from the `artifact_event` target to automate behaviors in response to artifacts.

> For samples of `ingest` and `export_complete`, see [Reference: Events](events.md#artifact-events).

### Example

```yaml
# Detection
target: artifact_event
event: export_complete
op: starts with
path: routing/log_type
value: pcap
case sensitive: false

# Response
- action: report
  name: PCAP Artifact ready to Download
```


