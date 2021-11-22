# Linux Sensor

The Linux sensor is one of LimaCharlie's EDR-class sensors. It's low-level and light-weight, interfacing with the kernel to acquire deep visibility into the host's activity while taking measures to preserve the host's performance. 

## Supported Events

* [`STARTING_UP`](../events.md#STARTING_UP)
* [`SHUTTING_DOWN`](../events.md#SHUTTING_DOWN)
* [`CONNECTED`](../events.md#CONNECTED)
* [`CLOUD_NOTIFICATION`](../events.md#CLOUD_NOTIFICATION)
* [`RECEIPT`](../events.md#RECEIPT)
* [`NEW_PROCESS`](../events.md#NEW_PROCESS)
* [`TERMINATE_PROCESS`](../events.md#TERMINATE_PROCESS)
* [`PROCESS_ENVIRONMENT`](../events.md#PROCESS_ENVIRONMENT)
* [`DNS_REQUEST`](../events.md#DNS_REQUEST)
* [`CODE_IDENTITY`](../events.md#CODE_IDENTITY)
* [`NEW_TCP4_CONNECTION`](../events.md#NEW_TCP4_CONNECTION)
* [`NEW_UDP4_CONNECTION`](../events.md#NEW_UDP4_CONNECTION)
* [`NEW_TCP6_CONNECTION`](../events.md#NEW_TCP6_CONNECTION)
* [`NEW_UDP6_CONNECTION`](../events.md#NEW_UDP6_CONNECTION)
* [`TERMINATE_TCP4_CONNECTION`](../events.md#TERMINATE_TCP4_CONNECTION)
* [`TERMINATE_UDP4_CONNECTION`](../events.md#TERMINATE_UDP4_CONNECTION)
* [`TERMINATE_TCP6_CONNECTION`](../events.md#TERMINATE_TCP6_CONNECTION)
* [`TERMINATE_UDP6_CONNECTION`](../events.md#TERMINATE_UDP6_CONNECTION)
* [`NETWORK_CONNECTIONS`](../events.md#NETWORK_CONNECTIONS)
* [`HIDDEN_MODULE_DETECTED`](../events.md#HIDDEN_MODULE_DETECTED)
* [`MODULE_LOAD`](../events.md#MODULE_LOAD)
* [`NETWORK_SUMMARY`](../events.md#NETWORK_SUMMARY)
* [`EXEC_OOB`](../events.md#EXEC_OOB)
* [`MODULE_MEM_DISK_MISMATCH`](../events.md#MODULE_MEM_DISK_MISMATCH)
* [`YARA_DETECTION`](../events.md#YARA_DETECTION)
* [`SERVICE_CHANGE`](../events.md#SERVICE_CHANGE)
* [`AUTORUN_CHANGE`](../events.md#AUTORUN_CHANGE)
* [`USER_OBSERVED`](../events.md#USER_OBSERVED)
* [`FIM_HIT`](../events.md#FIM_HIT)
* [`DATA_DROPPED`](../events.md#DATA_DROPPED)

## Supported Commands

* [`file_get`](../sensor_commands.md#file_get)
* [`file_info`](../sensor_commands.md#file_info)
* [`dir_list`](../sensor_commands.md#dir_list)
* [`dir_find_hash`](../sensor_commands.md#dir_find_hash)
* [`file_del`](../sensor_commands.md#file_del)
* [`file_mov`](../sensor_commands.md#file_mov)
* [`file_hash`](../sensor_commands.md#file_hash)
* [`mem_map`](../sensor_commands.md#mem_map)
* [`mem_read`](../sensor_commands.md#mem_read)
* [`mem_strings`](../sensor_commands.md#mem_strings)
* [`mem_find_string`](../sensor_commands.md#mem_find_string)
* [`os_services`](../sensor_commands.md#os_services)
* [`os_kill_process`](../sensor_commands.md#os_kill_process)
* [`os_suspend`](../sensor_commands.md#os_suspend)
* [`os_resume`](../sensor_commands.md#os_resume)
* [`os_processes`](../sensor_commands.md#os_processes)
* [`os_version`](../sensor_commands.md#os_version)
* [`hidden_module_scan`](../sensor_commands.md#hidden_module_scan)
* [`exfil_add`](../sensor_commands.md#exfil_add)
* [`exfil_del`](../sensor_commands.md#exfil_del)
* [`exfil_get`](../sensor_commands.md#exfil_get)
* [`restart`](../sensor_commands.md#restart)
* [`history_dump`](../sensor_commands.md#history_dump)
* [`set_performance_mode`](../sensor_commands.md#set_performance_mode)
* [`fim_add`](../sensor_commands.md#fim_add)
* [`fim_del`](../sensor_commands.md#fim_del)
* [`fim_get`](../sensor_commands.md#fim_get)
* [`yara_update`](../sensor_commands.md#yara_update)
* [`yara_scan`](../sensor_commands.md#yara_scan)
* [`deny_tree`](../sensor_commands.md#deny_tree)
* [`segregate_network`](../sensor_commands.md#segregate_network)
* [`rejoin_network`](../sensor_commands.md#rejoin_network)
* [`netstat`](../sensor_commands.md#netstat)
* [`dns_resolve`](../sensor_commands.md#dns_resolve)
* [`artifact_get`](../sensor_commands.md#artifact_get)
* [`run`](../sensor_commands.md#run)
* [`put`](../sensor_commands.md#put)
* [`pcap_ifaces`](../sensor_commands.md#pcap_ifaces)

## Artifacts

Given configured paths to collect from, the Linux sensor can batch upload logs / artifacts directly from the host.

Learn more about Artifacts [here](../external_logs.md).

## Payloads

For more complex needs not supported by [Events](../events.md), [Artifacts](../external_logs.md), or [Commands](../sensor_commands.md), it's possible to execute payloads on hosts via the Linux sensor.

Learn more about Payloads [here](../payloads.md).