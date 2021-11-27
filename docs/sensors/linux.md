# Linux Sensor

LimaCharlie's Linux sensor is one of the EDR-class sensors. It  interfaces with the kernel to acquire deep visibility into the host's activity while taking measures to preserve the host's performance. 

## Supported Events

* [`AUTORUN_CHANGE`](../events.md#autorun_change)
* [`CLOUD_NOTIFICATION`](../events.md#cloud_notification)
* [`CODE_IDENTITY`](../events.md#code_identity)
* [`CONNECTED`](../events.md#connected)
* [`DATA_DROPPED`](../events.md#data_dropped)
* [`DNS_REQUEST`](../events.md#dns_request)
* [`EXEC_OOB`](../events.md#exec_oob)
* [`FIM_HIT`](../events.md#fim_hit)
* [`HIDDEN_MODULE_DETECTED`](../events.md#hidden_module_detected)
* [`MODULE_LOAD`](../events.md#module_load)
* [`MODULE_MEM_DISK_MISMATCH`](../events.md#module_mem_disk_mismatch)
* [`NETWORK_CONNECTIONS`](../events.md#network_connections)
* [`NETWORK_SUMMARY`](../events.md#network_summary)
* [`NEW_PROCESS`](../events.md#new_process)
* [`NEW_TCP4_CONNECTION`](../events.md#new_tcp4_connection)
* [`NEW_UDP4_CONNECTION`](../events.md#new_udp4_connection)
* [`NEW_TCP6_CONNECTION`](../events.md#new_tcp6_connection)
* [`NEW_UDP6_CONNECTION`](../events.md#new_udp6_connection)
* [`PROCESS_ENVIRONMENT`](../events.md#process_environment)
* [`RECEIPT`](../events.md#receipt)
* [`SERVICE_CHANGE`](../events.md#service_change)
* [`SHUTTING_DOWN`](../events.md#shutting_down)
* [`STARTING_UP`](../events.md#starting_up)
* [`TERMINATE_PROCESS`](../events.md#terminate_process)
* [`TERMINATE_TCP4_CONNECTION`](../events.md#terminate_tcp4_connection)
* [`TERMINATE_UDP4_CONNECTION`](../events.md#terminate_udp4_connection)
* [`TERMINATE_TCP6_CONNECTION`](../events.md#terminate_tcp6_connection)
* [`TERMINATE_UDP6_CONNECTION`](../events.md#terminate_udp6_connection)
* [`USER_OBSERVED`](../events.md#user_observed)
* [`YARA_DETECTION`](../events.md#yara_detection)

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
