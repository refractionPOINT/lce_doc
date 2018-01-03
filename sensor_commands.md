# Sensor Commands

Sensor commands are commands that can be sent to the sensor (through the backend as an intermediary) to do various things.
These commands may rely on various collectors that may or may not be enabled on the sensor (see [Profiles](profiles.md) 
for instructions on enabling and disabling collectors).

Below is a high level listing of available commands and their purpose. Commands are sent like a command line interface
and may have positional or optional parameters. To get exact usage, either do a `GET` to the REST interface's `/tasks`
endpoint or issue the RPC `get_help` to the `c2/taskingproxy` category.

## Files and Directories

### file_get
Retrieve a file from the sensor.

### file_info
Get file information, timestamps, sizes etc.

### dir_list
List the contents of a directory.

### file_del
Delete a file from the sensor.

### file_mov
Move / rename a file on the sensor.

### file_hash
Compute the hash of the file on the sensor.


## Memory

### mem_map
Display the map of memory pages from a process including size, access rights etc.

### mem_read
Retrieve a chunk of memory from a process given a base address and size.

### mem_handles
List all open handles from a process (or all) on Windows.

### mem_strings
List strings from a process' memory.

### mem_find_string
Find specific strings in memory.

### mem_find_handle
Find specific open handles in memory on Windows.


## OS

### os_services
List all services (Windows, launchctl on MacOS and initd on Linux).

### os_drivers
List all drivers on Windows.

### os_kill_process
Kill a process running on the sensor.

### os_suspend
Suspend a process running on the sensor.

### os_resume
Resume execution of a process on the sensor.

### os_processes
List all running processes on the sensor.

### os_autoruns
List pieces of code executing at startup, similar to SysInternals autoruns.


## Anomalies

### hidden_module_scan
Look for hidden modules in a process' (or all) memory. Hidden modules are DLLs or dylibs loaded manually (not by the OS).

### exec_oob_scan
Look for threads executing code outside bounds of known modules in memory. Various process injection methodologies.

### hollowed_module_scan
Look for signs of process/module hollowing.


## Management

### exfil_add
Add an LC event to the list of events sent back to the backend by default.

### exfil_del
Remove an LC event from the list of events always sent back to the backend.

### exfil_get
List all LC events sent back to the backend by default.

### history_dump
Send to the backend the entire contents of the sensor event cache, so detailed events of everything that happenned recently.


## Yara

### yara_update
Update the compiled yara signature bundle that is being used for constant memory and file scanning on the sensor.

### yara_scan
Scan for a specific yara signature in memory and files on the sensor.


## Documents

### doc_cache_get
Retrieve a document / file that was cached on the sensor. (List of extensions/directories cached specified in [Profiles](profiles.md))


## Mitigation

### deny_tree
Tells the sensor that all activity starting at a specific process (and its children) should be denied and killed. Great for ransomware mitigation.

### segregate_network
Tells the sensor to stop all network connectivity on the host except LC comms to the backend. So it's network isolation, great to stop lateral movement.

### rejoin_network
Tells the sensor to allow network connectivity again (after it was segregated).
