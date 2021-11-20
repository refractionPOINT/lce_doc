# Events

## Overview

Events in LimaCharlie are in standard formatted JSON. 

```json json_schema
{
  "type": "object",
  "properties": {
    "event": {
      "type": "any",
      "description": "Schema is determined by the routing/event_type"
    },
    "routing": {
      "type": "object",
      "properties": {
        "this": {
          "type": "string",
          "description": "GUID (i.e. 1e9e242a512d9a9b16d326ac30229e7b) - see 'Atoms' section for more detail",
          "format": "Atom"
        },
        "event_type": {
          "type": "string",
          "description": "The event type (e.g. NEW_PROCESS, NETWORK_SUMMARY) dictates the 'event' schema"
        },
        "event_time": {
          "type": "integer",
          "description": "The time the event was observed on the host"
        },
        "event_id": {
          "type": "string",
          "format": "UUID"
        },
        "oid": {
          "type": "string",
          "format": "UUID",
          "description": "Organization ID"
        },
        "sid": {
          "type": ["string", "null"],
          "format": "UUID",
          "description": "Sensor ID"
        },
        "did": {
          "type": ["string", "null"],
          "format": "UUID",
          "description": "Device ID"
        },
        "iid": {
          "type": ["string", "null"],
          "format": "UUID",
          "description": "Installer Key ID"
        },
        "parent": {
          "type": ["string", "null"],
          "description": "Atom of possible parent event",
          "format": "Atom"
        },
        "target": {
          "type": ["string", "null"],
          "description": "Atom of possible target event",
          "format": "Atom"
        },
        "hostname": {
          "type": ["string", "null"],
        },
        "arch": {
          "type": ["integer", "null"],
          "description": "Integer corresponds with sensor architecture"
        },
        "plat": {
          "type": ["integer", "null"],
          "description": "Integer corresponds with sensor platform"
        },
        "tags": {
          "type": ["array"],
          "format": "string",
          "description": "Tags applied to sensor at the time the event was sent"
        },
      }
    }
  }
}
```

```example
{
  "event": {
    "BASE_ADDRESS": 140702709383168,
    "COMMAND_LINE": "C:\\\\Windows\\\\System32\\\\evil.exe -Embedding",
    "FILE_IS_SIGNED": 1,
    "FILE_PATH": "C:\\\\Windows\\\\System32\\\\evil.exe",
    "HASH": "5ef1322b96f176c4ea4b8304caf8b45e2e42c3188aa52ed1fd6196afc04b7297",
    "MEMORY_USAGE": 9515008,
    "PARENT": {
      "BASE_ADDRESS": 140697905135616,
      "COMMAND_LINE": "C:\\\\Windows\\\\system32\\\\unknown.exe -k Launch",
      "CREATION_TIME": 1625797634428,
      "FILE_IS_SIGNED": 1,
      "FILE_PATH": "C:\\\\Windows\\\\system32\\\\unknown.exe",
      "HASH": "438b6ccd84f4dd32d9684ed7d58fd7d1e5a75fe3f3d14ab6c788e6bb0ffad5e7",
      "MEMORY_USAGE": 19070976,
      "PARENT_ATOM": "ebf1884039c7650401b2198f60f89d2d",
      "PARENT_PROCESS_ID": 123,
      "PROCESS_ID": 1234,
      "THIS_ATOM": "ad48d1f14a8e5a114e85f79b60f89d2d",
      "THREADS": 14,
      "TIMESTAMP": 1626905901981,
      "USER_NAME": "NT AUTHORITY\\\\SYSTEM"
    },
    "PARENT_PROCESS_ID": 580,
    "PROCESS_ID": 5096,
    "THREADS": 6,
    "USER_NAME": "BUILTIN\\\\Administrators"
  },
  "routing": {
    "this": "655c970d2052b9f1c365839b611baf96",
    "parent": "ad48d1f14a3e5a114e85f79b60f89d2d",
    "arch": 2,
    "did": "3ef599f3-64dc-51f5-8322-62b0a6b8eef7",
    "event_id": "bdf6df69-b72c-470a-994b-216f1cdde9a7",
    "event_time": 1629204374140,
    "event_type": "NEW_PROCESS",
    "ext_ip": "123.456.78.901",
    "hostname": "test-host-123",
    "iid": "e22638c9-44a6-455a-83e2-a689ac9868a7",
    "int_ip": "10.4.34.227",
    "moduleid": 2,
    "oid": "8cbe27f4-agh1-4afb-ba19-138cd51389cd",
    "plat": 268435456,
    "sid": "d3d17f12-eecf-5287-b3a1-bf267aabb3cf",
    "tags": ["server"],
  },
}
```

Events can be observed and matched by [Detection & Response rules](dr.md) to automate behavior and can also be streamed via [Outputs](outputs.md) to the destination of your choice. 

## Streams

There are 6 different event streams moving through LimaCharlie:

| Name            |  Description                                                          | D&R Target      | Output  |
| --------------- | --------------------------------------------------------------------- | ---------------- | ------ |
| Telemetry       | Sensor events                                                         | `edr`            | ✅     |
| Detections      | Detections reported from D&R rules                                    | N/A              | ✅     |
| Deployment      | Meta-events relating to sensors coming online and quotas              | `deployment`     | ✅     |
| Artifacts       | Artifacts collected via REST API or via `artifact_get` sensor command | `artifact`       | ❌     |
| Artifact Events |  Lifecycle events for artifacts such as ingestion                     | `artifact_event` | ✅     |
| Audit           | Audit logs for management activity within LimaCharlie                 | N/A              | ✅     |


## Atoms

Atoms are Globally Unique Identifiers (GUIDs); here's one: `1e9e242a512d9a9b16d326ac30229e7b`. You can treat them as opaque values. These unique values are used to relate events together rather than using Process IDs, which are themselves unreliable.

Atoms can be found in up to 3 spots in an event:

* `routing/this`: current event
* `routing/parent`: parent of the current event
* `routing/target`: target of the current event

Using atom references from a single event, the entire chain of related events is constructed. For example:

```child_event
{
  "event": {...},
  "routing": {
    "this": "abcdef",
    "parent": "zxcv"
  }
}
```
```parent_event
{
  "event": {...},
  "routing": {
    "this": "zxcv",
    "parent": "poiuy"
  }
}
```

For processes, the parent relationship will simply be the parent process and child process (i.e. the parent spawned the child). Other events may be less obvious. For example for a `NETWORK_SUMMARY` event, the `parent` will be the process that generated the network connections.

> If using custom storage + searching solutions, you will likely want to index the values of `routing/this` and `routing/parent` for each event, doing so will allow you to very quickly find the root cause and actions of everything on your hosts.

Finally, the `routing/target` is only sometimes found in an event, and it represents a second related (without having a parent-child relationship). For example, in the `NEW_REMOTE_THREAD` event, this `target` represents the process where the remote thread was created.

## Going Deeper

Here are some suggested pages for learning more about events and their usage:

* [Reference: Events](events.md)
* [Reference: D&R Rules](dr.md)
