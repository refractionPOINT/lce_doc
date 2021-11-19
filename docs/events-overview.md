# Events

## Overview

Events in LimaCharlie are standardized JSON objects. 

```json
{
  "event": {
    /* content of the event, based on event type */
  },
  "routing": {
    "this": "655c970d2052b9f1c365839b611baf96" // event atom (explained more later)
    "arch": 2, // architecture of sensor (sensor-only)
    "did": "3ef599f3-64dc-51f5-8322-62b0a6b8eef7", // device ID (sensor-only)
    "event_id": "bdf6df69-b72c-470a-994b-216f1cdde9a7", // unique ID of event
    "event_time": 1629204374140, // time the event occurred on the host
    "event_type": "NEW_PROCESS", // event type - dictates shape of `event`
    "ext_ip": "123.456.78.901", // external IP (sensor-only)
    "hostname": "test-host-123", // hostname (sensor-only)
    "iid": "e22638c9-44a6-455a-83e2-a689ac9868a7", // installation key used to install sensor (sensor-only)
    "int_ip": "10.4.34.227", // internal IP (sensor-only)
    "moduleid": 2, // kernel module accessed to retrieve event - either 2 or 5 (sensor-only)
    "oid": "8cbe27f4-agh1-4afb-ba19-138cd51389cd", // organization ID
    "parent": "ad48d1f14a3e5a114e85f79b60f89d2d", // parent event atom
    "plat": 268435456, // platform of sensor (sensor-only)
    "sid": "d3d17f12-eecf-5287-b3a1-bf267aabb3cf", // sensor ID (sensor-only)
    "tags": ["server"], // tags applied to sensor (sensor-only)
  },
}
```

Events can be observed and matched by [Detection & Response rules](dr.md) to automate behavior, and they can be passed via [Outputs](outputs.md) to the destination of your choice. 

## Streams

There are 6 different event streams moving through LimaCharlie:

| Name            | Rule Target      |  Description                                                          | Output Available |
| --------------- | ---------------- | --------------------------------------------------------------------- | ------------- |
| Telemetry       | `edr`            | Platform-specific telemetry coming from Sensors                       | ✅ |
| Detections      | N/A              | Detections reported from D&R rules                                    | ✅ |
| Deployment      | `deployment`     | Meta-events relating to sensors coming online and quotas              | ✅ |
| Artifacts       | `artifact`       | Artifacts collected via REST API or via `artifact_get` sensor command | ❌ |
| Artifact Events | `artifact_event` |  Lifecycle events for artifacts such as ingestion                     | ✅ |
| Audit           | N/A              | Audit logs for management activity within LimaCharlie                 | ✅ |


## Common Information

Some common elements to events are worth pointing out. Those elements have been removed from the events below, only leaving
the information unique to the event. The actual event stream will contain much more information for each event.

* routing/this is a UUID generated for every event in the sensor.
* routing/parent is a reference to the parent event's routing/this, providing strong relationships (much more reliable than simple process IDs)
between the events. This allows you to get the extremely powerful explorer view.
* routing/event_time is the time (UTC) the sensor produced the event.
* routing/hostname is the hostname of where the event came from.
* routing/tags is the list of tags associated with the agent where the event came from.

### Atoms
Atoms can be found in 3 locations:

* routing/parent
* routing/this
* routing/target

Atoms are Globally Unique Identifiers that look like this: `1e9e242a512d9a9b16d326ac30229e7b`. You can treat it as an opaque value. These unique values
are used to relate events together without the need to use clunky and unreliable things like Process IDs.

The `routing/this` Atom reprents the indentifier for the current event. The `routing/parent` Atom in an event tells you the global identifier for the
parent event of the current event. Using these two Atoms, you can create an entire chain of event.

For processes, this parent relationship is simply the parent process and child process (parent spawned child), but for other less obvious events, the
nature of relationship varies. For example for a `NETWORK_SUMMARY` event, the parent is the process that generated the network connections.

Depending on the exact storage and searching solution you are using, you will likely want to index the values of `routing/this` and `routing/parent` for
each event, doing so will allow you to very quickly find the root cause and actions of everything on your hosts.

Finally, the `routing/target` is only sometimes found in an event, and it represents a second related (without having a parent-child relationship). For
example, in the `NEW_REMOTE_THREAD` event, this `target` represents the process where the remote thread was created.

Basic example:

Event 1
```json
{
  "routing": {
    "this": "abcdef",
    "parent": "zxcv"
  }
}
```

Event 2
```json
{
  "routing": {
    "this": "zxcv",
    "parent": "poiuy"
  }
}
```

Means that Event 1 is the parent of Event 2 (`Event1 ---> Event2`).
