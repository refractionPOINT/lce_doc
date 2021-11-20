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

To see samples of what each of the `deployment` events looks like, see [Reference: Events](https://doc.limacharlie.io/docs/documentation/ZG9jOjE5MzExMDQ-events#deployment-events).

## Target: artifact

Parsed artifacts also can run through the rule engine as if they were regular `edr` events, but there are some key differences. 

### Supported Operators

The `artifact` target supports a subset of operators under `op`:

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

### Specific Parameters

* `artifact path`: matches the start of the artifact's `path` string, e.g. `/auth.log`
* `artifact type`: matches the artifact's `type` string, e.g. `pcap`, `zeek`, `auth`, `wel`
* `artifact source`: matches the artifact's `source` string, e.g. `hostname-123`


## Target: artifact_event

