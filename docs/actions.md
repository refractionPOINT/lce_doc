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

### Limiting Scope

There are two mechanisms for limiting scope of a `report`:

* Specifying `publish: false`
* Prefixing `name` with `__` (double underscore)

Setting `publish: false` is used to set the detection as strictly intermediary - the only place it will be visible is to the rule engine so it can be chained in another D&R rule, selectable by using `event: _DETECTIONNAME`.

The `__` double underscore naming approach functions similarly to `publish: false`, but allows Services to see the detection. 

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

> For more information on using variables, see [Using Sensor Variables](sensor-variables.md).

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