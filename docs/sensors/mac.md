# Mac Sensor

LimaCharlie's Mac sensor is one of the EDR-class sensors. It interfaces with the kernel to acquire deep visibility into the host's activity while taking measures to preserve the host's performance. 

## Supported Events

* [`AUTORUN_CHANGE`](../events.md#AUTORUN_CHANGE)
* [`CLOUD_NOTIFICATION`](../events.md#CLOUD_NOTIFICATION)
* [`CODE_IDENTITY`](../events.md#CODE_IDENTITY)
* [`CONNECTED`](../events.md#CONNECTED)
* [`DATA_DROPPED`](../events.md#DATA_DROPPED)
* [`DNS_REQUEST`](../events.md#DNS_REQUEST)
* [`EXEC_OOB`](../events.md#EXEC_OOB)
* [`FILE_CREATE`](../events.md#FILE_CREATE)
* [`FILE_DELETE`](../events.md#FILE_DELETE)
* [`FILE_MODIFIED`](../events.md#FILE_MODIFIED)
* [`FILE_TYPE_ACCESSED`](../events.md#FILE_TYPE_ACCESSED)
* [`FIM_HIT`](../events.md#FIM_HIT)
* [`HIDDEN_MODULE_DETECTED`](../events.md#HIDDEN_MODULE_DETECTED)
* [`MODULE_LOAD`](../events.md#MODULE_LOAD)
* [`MODULE_MEM_DISK_MISMATCH`](../events.md#MODULE_MEM_DISK_MISMATCH)
* [`NETWORK_CONNECTIONS`](../events.md#NETWORK_CONNECTIONS)
* [`NETWORK_SUMMARY`](../events.md#NETWORK_SUMMARY)
* [`NEW_DOCUMENT`](../events.md#NEW_DOCUMENT)
* [`NEW_PROCESS`](../events.md#NEW_PROCESS)
* [`NEW_TCP4_CONNECTION`](../events.md#NEW_TCP4_CONNECTION)
* [`NEW_TCP6_CONNECTION`](../events.md#NEW_TCP6_CONNECTION)
* [`NEW_UDP4_CONNECTION`](../events.md#NEW_UDP4_CONNECTION)
* [`NEW_UDP6_CONNECTION`](../events.md#NEW_UDP6_CONNECTION)
* [`RECEIPT`](../events.md#RECEIPT)
* [`SERVICE_CHANGE`](../events.md#SERVICE_CHANGE)
* [`SHUTTING_DOWN`](../events.md#SHUTTING_DOWN)
* [`STARTING_UP`](../events.md#STARTING_UP)
* [`TERMINATE_PROCESS`](../events.md#TERMINATE_PROCESS)
* [`TERMINATE_TCP4_CONNECTION`](../events.md#TERMINATE_TCP4_CONNECTION)
* [`TERMINATE_TCP6_CONNECTION`](../events.md#TERMINATE_TCP6_CONNECTION)
* [`TERMINATE_UDP4_CONNECTION`](../events.md#TERMINATE_UDP4_CONNECTION)
* [`TERMINATE_UDP6_CONNECTION`](../events.md#TERMINATE_UDP6_CONNECTION)
* [`USER_OBSERVED`](../events.md#USER_OBSERVED)
* [`VOLUME_MOUNT`](../events.md#VOLUME_MOUNT)
* [`VOLUME_UNMOUNT`](../events.md#VOLUME_UNMOUNT)
* [`YARA_DETECTION`](../events.md#YARA_DETECTION)

## Supported Commands

* [`artifact_get`](../sensor_commands.md#artifact_get)
* [`deny_tree`](../sensor_commands.md#deny_tree)
* [`dir_find_hash`](../sensor_commands.md#dir_find_hash)
* [`dir_list`](../sensor_commands.md#dir_list)
* [`dns_resolve`](../sensor_commands.md#dns_resolve)
* [`doc_cache_get`](../sensor_commands.md#doc_cache_get)
* [`exfil_add`](../sensor_commands.md#exfil_add)
* [`exfil_del`](../sensor_commands.md#exfil_del)
* [`exfil_get`](../sensor_commands.md#exfil_get)
* [`file_del`](../sensor_commands.md#file_del)
* [`file_get`](../sensor_commands.md#file_get)
* [`file_hash`](../sensor_commands.md#file_hash)
* [`file_info`](../sensor_commands.md#file_info)
* [`file_mov`](../sensor_commands.md#file_mov)
* [`fim_add`](../sensor_commands.md#fim_add)
* [`fim_del`](../sensor_commands.md#fim_del)
* [`fim_get`](../sensor_commands.md#fim_get)
* [`hidden_module_scan`](../sensor_commands.md#hidden_module_scan)
* [`history_dump`](../sensor_commands.md#history_dump)
* [`mem_find_handle`](../sensor_commands.md#mem_find_handle)
* [`mem_find_string`](../sensor_commands.md#mem_find_string)
* [`mem_handles`](../sensor_commands.md#mem_handles)
* [`mem_map`](../sensor_commands.md#mem_map)
* [`mem_read`](../sensor_commands.md#mem_read)
* [`mem_strings`](../sensor_commands.md#mem_strings)
* [`netstat`](../sensor_commands.md#netstat)
* [`os_autoruns`](../sensor_commands.md#os_autoruns)
* [`os_kill_process`](../sensor_commands.md#os_kill_process)
* [`os_processes`](../sensor_commands.md#os_processes)
* [`os_resume`](../sensor_commands.md#os_resume)
* [`os_services`](../sensor_commands.md#os_services)
* [`os_suspend`](../sensor_commands.md#os_suspend)
* [`os_version`](../sensor_commands.md#os_version)
* [`put`](../sensor_commands.md#put)
* [`reg_list`](../sensor_commands.md#reg_list)
* [`rejoin_network`](../sensor_commands.md#rejoin_network)
* [`restart`](../sensor_commands.md#restart)
* [`run`](../sensor_commands.md#run)
* [`segregate_network`](../sensor_commands.md#segregate_network)
* [`set_performance_mode`](../sensor_commands.md#set_performance_mode)
* [`uninstall`](../sensor_commands.md#uninstall)
* [`yara_scan`](../sensor_commands.md#yara_scan)
* [`yara_update`](../sensor_commands.md#yara_update)

## Artifacts

Given configured paths to collect from, the Mac sensor can batch upload logs / artifacts directly from the host.

Learn more about collecting Artifacts [here](../external_logs.md).

## Payloads

For more complex needs not supported by [Events](../events.md), [Artifacts](../external_logs.md), or [Commands](../sensor_commands.md), it's possible to execute payloads on hosts via the Mac sensor.

Learn more about executing Payloads [here](../payloads.md).