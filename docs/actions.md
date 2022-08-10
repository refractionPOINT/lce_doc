# Reference: Actions

Actions are used in the Response part of a Detection & Response rule.

> For more information on how to use Actions, read [Detection & Response Rules](dr.md). 

## task

```yaml
- action: task
  command: history_dump
  investigation: susp-process-inv
```

Sends a task in the `command` parameter to the sensor that the event under evaluation is from.

An optional `investigation` parameter can be given to create a unique identifier for the task and any events emitted from the sensor as a result of the task.

The `command` parameter supports [string templates](./template_and_transforms.md) like `artifact_get {{ .event.FILE_PATH }}`.

> To view all possible commands, see [Reference: Sensor Commands](sensor_commands.md)

## report

```yaml
- action: report
  name: my-detection-name
  publish: true # defaults to true
  priority: 3   # optional
  metadata:     # optional & free-form
    author: Alice (alice@wonderland.com)
```

Reports the match as a detection. Think of it as an alert. Detections go a few places:

* The `detection` Output stream
* The organization's Detections page (if [`insight`](https://app.limacharlie.io/add-ons/detail/insight) is enabled)
* The D&R rule engine, for chaining detections

The `name` parameter supports [string templates](./template_and_transforms.md) like `detected {{ .cat }} on {{ .routing.hostname }}`.

### Limiting Scope

There is a mechanism for limiting scope of a `report`, prefixing `name` with `__` (double underscore). This will cause the detection
generated to be visible to chained D&R rules and Services, but the detection will *not* be sent to the Outputs for storage.

This is a useful mechanism to automate behavior using D&R rules without generating extra traffic that is not useful.

### Optional Parameters

The `priority` parameter, if set, should be an integer. It will be added to the root of the detection report as `priority`.

The `metadata` parameter, if set, can include any data. It will be added to the root of the detection report as `detect_mtd`. This can be used to include information for internal use like reference numbers or URLs.

## add tag, remove tag

```yaml
- action: add tag
  tag: vip
  entire_device: false # defaults to false
  ttl: 30 # optional
```

Adds or removes tags on the sensor. 

### Optional Parameters

The `add tag` action can optionally take a `ttl` parameter that is a number of seconds the tag should remain applied to the sensor.

The `add tag` action can optionally have the `entire_device` parameter set to `true`. When enabled, the new tag will apply to the entire [Device ID](agentid.md#device-ids), meaning that every sensor that shares this Device ID will have the tag applied (and relevant TTL). If a Device ID is unavailable for the sensor, it will still be tagged.

This can be used as a mechanism to synchronize and operate changes across an entire device. A D&R rule could detect a behavior and then tag all sensors on the device so they may act accordingly, like lc-net to start doing full pcap.

For example, this would apply the `full_pcap` to all sensors on the device for 5 minutes:

```yaml
- action: add tag
  tag: full_pcap
  ttl: 300
  entire_device: true
```

## add var, del var

Add or remove a value from the variables associated with a sensor.

```yaml
- action: add var
  name: my-variable
  value: <<event/VOLUME_PATH>>
  ttl: 30 # optional
```

The `add var` action can optionally take a `ttl` parameter that is a number of seconds the variable should remain in state for the sensor.

## service request

Perform an asynchronous request to a service the organization is subscribed to. 

```yaml
- action: service request
  name: dumper # name of the service
  request:     # request parameters
    sid: <<routing/sid>>
    retention: 3
```

The `request` parameters will vary depending on the service (see the relevant service's documentation). Parameters can also leverage [lookback](#lookback) values (i.e. `<<path/to/value>>`) from the detected event.

## isolate network

Isolates the sensor from the network in a persistent fashion (if the sensor/host reboots, it will remain isolated). Only works on platforms supporting the `segregate_network` [sensor command](sensor_commands.md#segregate_network).

```yaml
- action: isolate network
```

## rejoin network

Removes the isolation status of a sensor that had it set using `isolate network`.

```yaml
- action: rejoin network
```

## undelete sensor

Un-deletes a sensor that was previously deleted. 

```yaml
- action: undelete sensor
```

This can be used in conjunction with the [deleted_sensor](events.md#deleted_sensor) event to allow sensors to rejoin the fleet.

## wait

Adds a delay (up to 1 minute) before running the next response action.

This can be useful if a previous response action needs to finish running (i.e. a command or payload run via `task`) before you can execute the next action.

> The `wait` action will block processing any events from that sensor for the specified duration of time. This is because D&R  rules are run at wire-speed and in-order.

The `duration` parameter supports two types of values:
* A string describing a duration, like `5s` for 5 seconds or `10ms` for 10 miliseconds, as defined by [this function call](https://pkg.go.dev/time#ParseDuration).
* An integer representing a number of seconds.

Example:
```yaml
- action: wait
  duration: 10s
```

and

```yaml
- action: wait
  duration: 5
```

## output

Forwards the matched event to an Output identified by `name` in the `tailored` [stream](https://doc.limacharlie.io/docs/documentation/ZG9jOjE5MzExMTY-outputs#tailored-stream).

This allows you to create highly granular Outputs for specific events.

The `name` parameter is the name of the Output.

Example:
```yaml
- action: output
  name: my-output
```
