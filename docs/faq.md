# FAQ
  
[TOC]

### Why do I get Unauthorized errors from the REST API?
* Make sure the API endpoint you're trying to reach is enabled
  for LimaCharlie Cloud customers. The supported endpoints are
  the ones listed in the "LimaCharlie Cloud" category [here](https://api.limacharlie.io/static/swagger/#/LimaCharlie_Cloud).
* If you are using the tasking API to send tasks to sensors, make sure you are
  subscribed to the the "tasking" add-on, otherwise your access tokens will lack the
  privilege required.

### How do I select which events are sent back to me?
* Only certain events are sent back to the cloud for performance reasons.
* All events sent to the cloud are always sent to whatever Output you've configured.
* You can trigger the retrieval of additional events from the sensor through two ways:
  1. Sending the [`history_dump`](sensor_commands.md) task to a sensor will tell it to send home all events cached in memory.
  1. Using the [`add_exfil`](sensor_commands.md) task to a sensor will tell it to send all instances of a specific event
     home for a specific amount of time.
* This means a common strategy is to have "first level" detections that look for general
  suspicious behavior, and when necessary for those detections to trigger `history_dump` to get full context.

### How do LimaCharlie events map with Sysmon events on Windows?
Many events generated in LimaCharlie have a good analog event in Sysmon (as described [here](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)):

* Event ID 1 (Process creation): [NEW_PROCES](events.md#new_process)
* Event ID 3 (Network connection):  [NEW_*_CONNECTION](events.md#new_tcp4_connection)
* Event ID 5 (Process terminated): [TERMINATE_PROCESS](events.md#terminate_process)
* Event ID 6 (Driver loaded): [MODULE_LOAD](events.md#module_load), [CODE_IDENTITY](events.md#code_identity), [DRIVER_CHANGE](events.md#driver_change)
* Event ID 7 (Image loaded): [MODULE_LOAD](events.md#module_load), [CODE_IDENTITY](events.md#code_identity)
* Event ID 8 (Create remote thread): [NEW_REMOTE_THREAD](events.md#new_remote_thread)
* Event ID 10 (ProcessAccess): [REMOTE_PROCESS_HANDLE](events.md#remote_process_handle)
* Event ID 11 (FileCreate): [FILE_CREATE](events.md#file_create)
* Event ID 12 (RegistryEvent object create and delete): [REGISTRY_CREATE](events.md#registry_create), [REGISTRY_DELETE](events.md#registry_delete)
* Event ID 13 (RegistryEvent value set): [REGISTRY_WRITE](events.md#registry_write)
* Event ID 14 (RegistryEvent rename): [REGISTRY_CREATE](events.md#registry_create)
* Event ID 17 (PipeEvent created): [NEW_NAMED_PIPE](events.md#new_named_pipe)
* Event ID 18 (PipeEvent connected): [OPEN_NAMED_PIPE](events.md#open_named_pipe)

Obviously, we also have [tons of other events](events.md) that are not found in Sysmon.

### Why do I get an error 110 when isolating a host from the network?
The `segregate_network` command requires kernel support to be running on the target host. Kernel support is not always
available depending on the operating system type and version. [Error 110](errors.md) signifies `ERROR_OPEN_FAILED` which
means the sensor failed to access the kernel component. You can view the status of kernel access via the sensor list
of your organization or the REST API.

Currently supported OSes and versions kernel access:

* Windows 7 and up.
* MacOS 10.7 and up.
