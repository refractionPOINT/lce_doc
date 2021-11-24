# Linux Sensor

LimaCharlie's Linux sensor is one of the EDR-class sensors. It  interfaces with the kernel to acquire deep visibility into the host's activity while taking measures to preserve the host's performance. 

## Supported Events

* [`AUTORUN_CHANGE`](../events.md#AUTORUN_CHANGE)
* [`CLOUD_NOTIFICATION`](../events.md#CLOUD_NOTIFICATION)
* [`CODE_IDENTITY`](../events.md#CODE_IDENTITY)
* [`CONNECTED`](../events.md#CONNECTED)
* [`DATA_DROPPED`](../events.md#DATA_DROPPED)
* [`DNS_REQUEST`](../events.md#DNS_REQUEST)
* [`EXEC_OOB`](../events.md#EXEC_OOB)
* [`FIM_HIT`](../events.md#FIM_HIT)
* [`HIDDEN_MODULE_DETECTED`](../events.md#HIDDEN_MODULE_DETECTED)
* [`MODULE_LOAD`](../events.md#MODULE_LOAD)
* [`MODULE_MEM_DISK_MISMATCH`](../events.md#MODULE_MEM_DISK_MISMATCH)
* [`NETWORK_CONNECTIONS`](../events.md#NETWORK_CONNECTIONS)
* [`NETWORK_SUMMARY`](../events.md#NETWORK_SUMMARY)
* [`NEW_PROCESS`](../events.md#NEW_PROCESS)
* [`NEW_TCP4_CONNECTION`](../events.md#NEW_TCP4_CONNECTION)
* [`NEW_UDP4_CONNECTION`](../events.md#NEW_UDP4_CONNECTION)
* [`NEW_TCP6_CONNECTION`](../events.md#NEW_TCP6_CONNECTION)
* [`NEW_UDP6_CONNECTION`](../events.md#NEW_UDP6_CONNECTION)
* [`PROCESS_ENVIRONMENT`](../events.md#PROCESS_ENVIRONMENT)
* [`RECEIPT`](../events.md#RECEIPT)
* [`SERVICE_CHANGE`](../events.md#SERVICE_CHANGE)
* [`STARTING_UP`](../events.md#STARTING_UP)
* [`SHUTTING_DOWN`](../events.md#SHUTTING_DOWN)
* [`TERMINATE_PROCESS`](../events.md#TERMINATE_PROCESS)
* [`TERMINATE_TCP4_CONNECTION`](../events.md#TERMINATE_TCP4_CONNECTION)
* [`TERMINATE_UDP4_CONNECTION`](../events.md#TERMINATE_UDP4_CONNECTION)
* [`TERMINATE_TCP6_CONNECTION`](../events.md#TERMINATE_TCP6_CONNECTION)
* [`TERMINATE_UDP6_CONNECTION`](../events.md#TERMINATE_UDP6_CONNECTION)
* [`USER_OBSERVED`](../events.md#USER_OBSERVED)
* [`YARA_DETECTION`](../events.md#YARA_DETECTION)

## Supported Commands

* [`artifact_get`](../sensor_commands.md#artifact_get)
* [`deny_tree`](../sensor_commands.md#deny_tree)
* [`dir_find_hash`](../sensor_commands.md#dir_find_hash)
* [`dir_list`](../sensor_commands.md#dir_list)
* [`dns_resolve`](../sensor_commands.md#dns_resolve)
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
* [`mem_find_string`](../sensor_commands.md#mem_find_string)
* [`mem_map`](../sensor_commands.md#mem_map)
* [`mem_read`](../sensor_commands.md#mem_read)
* [`mem_strings`](../sensor_commands.md#mem_strings)
* [`netstat`](../sensor_commands.md#netstat)
* [`os_kill_process`](../sensor_commands.md#os_kill_process)
* [`os_processes`](../sensor_commands.md#os_processes)
* [`os_resume`](../sensor_commands.md#os_resume)
* [`os_suspend`](../sensor_commands.md#os_suspend)
* [`os_services`](../sensor_commands.md#os_services)
* [`os_version`](../sensor_commands.md#os_version)
* [`pcap_ifaces`](../sensor_commands.md#pcap_ifaces)
* [`put`](../sensor_commands.md#put)
* [`rejoin_network`](../sensor_commands.md#rejoin_network)
* [`restart`](../sensor_commands.md#restart)
* [`run`](../sensor_commands.md#run)
* [`segregate_network`](../sensor_commands.md#segregate_network)
* [`set_performance_mode`](../sensor_commands.md#set_performance_mode)
* [`yara_scan`](../sensor_commands.md#yara_scan)
* [`yara_update`](../sensor_commands.md#yara_update)

## Artifacts

Given configured paths to collect from, the Linux sensor can batch upload logs / artifacts directly from the host.

Learn more about collecting Artifacts [here](../external_logs.md).

## Payloads

For more complex needs not supported by [Events](../events.md), [Artifacts](../external_logs.md), or [Commands](../sensor_commands.md), it's possible to execute payloads on hosts via the Linux sensor.

Learn more about executing Payloads [here](../payloads.md).
