# Windows Sensor

LimaCharlie's Windows sensor is one of the EDR-class sensors. It interfaces with the kernel to acquire deep visibility into the host's activity while taking measures to preserve the host's performance. 

Supports Windows XP 32 bit and up.

## Supported Events

* [`AUTORUN_CHANGE`](../events.md#autorun_change)
* [`CLOUD_NOTIFICATION`](../events.md#cloud_notification)
* [`CODE_IDENTITY`](../events.md#code_identity)
* [`CONNECTED`](../events.md#connected)
* [`DATA_DROPPED`](../events.md#data_dropped)
* [`DNS_REQUEST`](../events.md#dns_request)
* [`DRIVER_CHANGE`](../events.md#driver_change)
* [`EXEC_OOB`](../events.md#exec_oob)
* [`FILE_CREATE`](../events.md#file_create)
* [`FILE_DELETE`](../events.md#file_delete)
* [`FILE_MODIFIED`](../events.md#file_modified)
* [`FILE_TYPE_ACCESSED`](../events.md#file_type_accessed)
* [`FIM_HIT`](../events.md#fim_hit)
* [`HIDDEN_MODULE_DETECTED`](../events.md#hidden_module_detected)
* [`MODULE_LOAD`](../events.md#module_load)
* [`MODULE_MEM_DISK_MISMATCH`](../events.md#module_mem_disk_mismatch)
* [`NETWORK_CONNECTIONS`](../events.md#network_connections)
* [`NETWORK_SUMMARY`](../events.md#network_summary)
* [`NEW_DOCUMENT`](../events.md#new_document)
* [`NEW_NAMED_PIPE`](../events.md#new_named_pipe)
* [`NEW_PROCESS`](../events.md#new_process)
* [`NEW_REMOTE_THREAD`](../events.md#new_remote_thread)
* [`NEW_TCP4_CONNECTION`](../events.md#new_tcp4_connection)
* [`NEW_UDP4_CONNECTION`](../events.md#new_udp4_connection)
* [`NEW_TCP6_CONNECTION`](../events.md#new_tcp6_connection)
* [`NEW_UDP6_CONNECTION`](../events.md#new_udp6_connection)
* [`OPEN_NAMED_PIPE`](../events.md#open_named_pipe)
* [`PROCESS_ENVIRONMENT`](../events.md#process_environment)
* [`RECEIPT`](../events.md#receipt)
* [`REGISTRY_CREATE`](../events.md#registry_create)
* [`REGISTRY_DELETE`](../events.md#registry_delete)
* [`REGISTRY_WRITE`](../events.md#registry_write)
* [`REMOTE_PROCESS_HANDLE`](../events.md#remote_process_handle)
* [`SENSITIVE_PROCESS_ACCESS`](../events.md#sensitive_process_access)
* [`SERVICE_CHANGE`](../events.md#service_change)
* [`SHUTTING_DOWN`](../events.md#shutting_down)
* [`STARTING_UP`](../events.md#starting_up)
* [`TERMINATE_PROCESS`](../events.md#terminate_process)
* [`TERMINATE_TCP4_CONNECTION`](../events.md#terminate_tcp4_connection)
* [`TERMINATE_UDP4_CONNECTION`](../events.md#terminate_udp4_connection)
* [`TERMINATE_TCP6_CONNECTION`](../events.md#terminate_tcp6_connection)
* [`TERMINATE_UDP6_CONNECTION`](../events.md#terminate_udp6_connection)
* [`THREAD_INJECTION`](../events.md#thread_injection)
* [`USER_OBSERVED`](../events.md#user_observed)
* [`VOLUME_MOUNT`](../events.md#volume_mount)
* [`VOLUME_UNMOUNT`](../events.md#volume_unmount)
* [`WEL`](../events.md#wel)
* [`YARA_DETECTION`](../events.md#yara_detection)

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
* [`os_drivers`](../sensor_commands.md#os_drivers)
* [`os_kill_process`](../sensor_commands.md#os_kill_process)
* [`os_packages`](../sensor_commands.md#os_packages)
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

Given configured paths to collect from, the Windows sensor can batch upload logs / artifacts directly from the host.

Learn more about collecting Artifacts [here](../external_logs.md).

## Payloads

For more complex needs not supported by [Events](../events.md), [Artifacts](../external_logs.md), or [Commands](../sensor_commands.md), it's possible to execute payloads on hosts via the Windows sensor.

Learn more about executing Payloads [here](../payloads.md).

## Microsoft Defender

The Windows sensor can listen, alert, and automate based on various Defender events.

This is done by [ingesting artifacts from the Defender Event Log Source](../external_logs.md#windows-event-logs) and using [Detection & Response rules](../dr.md) to take the appropriate action.

A config template to alert on the common Defender events of interest is available [here](https://github.com/refractionPOINT/templates/blob/master/anti-virus/windows-defender.yaml). The template can be used in conjunction with [`infrastructure-service`](https://doc.limacharlie.io/docs/documentation/docs/infrastructure-service.md) or its user interface in the [web app](https://app.limacharlie.io).

Specifically, the template alerts on the following Defender events:
* windows-defender-malware-detected (`event ID 1006`)
* windows-defender-history-deleted (`event ID 1013`)
* windows-defender-behavior-detected (`event ID 1015`)
* windows-defender-activity-detected (`event ID 1116`)
