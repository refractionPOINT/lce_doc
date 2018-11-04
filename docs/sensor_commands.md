# Sensor Commands

[TOC]

Sensor commands are commands that can be sent to the sensor (through the backend as an intermediary) to do various things.
These commands may rely on various collectors that may or may not be currently enabled on the sensor and have been marked as such.

Below is a high level listing of available commands and their purpose. Commands are sent like a command line interface
and may have positional or optional parameters. To get exact usage, either do a `GET` to the REST interface's `/tasks`
endpoint or issue the RPC `get_help` to the `c2/taskingproxy` category.

When issuing a task, the expected answer from the REST interface is an empty (`{}`) 200 OK. This because responses
from the sensor to a task may come right away or may trickle in over time (like in the case of the Yara scanning). To
prevent the REST interface from blocking for very long times, the responses to the tasks are simply sent as part
of the normal data flow from the sensor as response events. This means you can find the responses through the data in the
Output you have configured.

To assist in find the responses more easily, the `investigation_id` mechanism was created. When issuing a taks, including
an `investigation_id`, which is simply an arbitrary string you define, will include that ID in all related responses from
the sensor (`routing/investigation_id`). Note that Outputs also support the `inv_id` parameter that allows you to create
an Output that will only receive data related to an investigation ID.

A common scheme is to set an investigation ID in all tasks sent during an interactive session and
to create an Output with this specific ID for the duration of the session. That way you can find all the
responses from your session in one place.

When you issue a task, you will see `CLOUD_NOTIFICATION` events coming back from your
sensor. Those events are simply "receipts" from your sensor to let you know they have
received a task and the contents of that task.

## Files and Directories

### file_get
Retrieve a file from the sensor.

```
usage: file_get [-h] file

positional arguments:
  file        file path to file to get

optional arguments:
  -h, --help  show this help message and exit
```

### file_info
Get file information, timestamps, sizes etc.

```
usage: file_info [-h] file

positional arguments:
  file        file path to file to get info on

optional arguments:
  -h, --help  show this help message and exit
```

### dir_list
List the contents of a directory.

```
usage: dir_list [-h] [-d DEPTH] rootDir fileExp

positional arguments:
  rootDir               the root directory where to begin the listing from
  fileExp               a file name expression supporting basic wildcards like
                        * and ?

optional arguments:
  -h, --help            show this help message and exit
  -d DEPTH, --depth DEPTH
                        optional maximum depth of the listing, defaults to a
                        single level
```

### dir_find_hash
Find files matching hashes starting at a root directory.

```
usage: dir_find_hash [-h] [-d DEPTH] --hash HASHES rootDir fileExp

positional arguments:
  rootDir               the root directory where to begin the search from
  fileExp               a file name expression supporting basic wildcards like
                        * and ?

optional arguments:
  -h, --help            show this help message and exit
  -d DEPTH, --depth DEPTH
                        optional maximum depth of the listing, defaults to a
                        single level
  --hash HASHES         sha256 to search for, can be specified multiple times
```

### file_del
Delete a file from the sensor.

```
usage: file_del [-h] file

positional arguments:
  file        file path to delete

optional arguments:
  -h, --help  show this help message and exit
```

### file_mov
Move / rename a file on the sensor.

```
usage: file_mov [-h] srcFile dstFile

positional arguments:
  srcFile     source file path
  dstFile     destination file path

optional arguments:
  -h, --help  show this help message and exit
```

### file_hash
Compute the hash of the file on the sensor.

```
usage: file_hash [-h] file

positional arguments:
  file        file path to hash

optional arguments:
  -h, --help  show this help message and exit
```

## Memory

### mem_map
Display the map of memory pages from a process including size, access rights etc.

**Due to recent changes in MacOS, may be less reliable on that platform.**

```
usage: mem_map [-h] [-p PID] [-a PROCESSATOM]

optional arguments:
  -h, --help            show this help message and exit
  -p PID, --pid PID     pid of the process to get the map from
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target proces
```

### mem_read
Retrieve a chunk of memory from a process given a base address and size.

**Due to recent changes in MacOS, may be less reliable on that platform.**

```
usage: mem_read [-h] [-p PID] [-a PROCESSATOM] baseAddr memSize

positional arguments:
  baseAddr              base address to read from, in HEX FORMAT
  memSize               number of bytes to read, in HEX FORMAT

optional arguments:
  -h, --help            show this help message and exit
  -p PID, --pid PID     pid of the process to get the map from
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
```

### mem_handles
List all open handles from a process (or all) on Windows.

```
usage: mem_handles [-h] [-p PID] [-a PROCESSATOM]

optional arguments:
  -h, --help            show this help message and exit
  -p PID, --pid PID     pid of the process to get the handles from, 0 for all
                        processes
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
```

### mem_strings
List strings from a process' memory.

**Due to recent changes in MacOS, may be less reliable on that platform.**

```
usage: mem_strings [-h] [-p PID] [-a PROCESSATOM]

optional arguments:
  -h, --help            show this help message and exit
  -p PID, --pid PID     pid of the process to get the strings from
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
```


### mem_find_string
Find specific strings in memory.

**Due to recent changes in MacOS, may be less reliable on that platform.**

```
usage: mem_find_string [-h] -s [STRINGS [STRINGS ...]] pid

positional arguments:
  pid                   pid of the process to search in

optional arguments:
  -h, --help            show this help message and exit
  -s [STRINGS [STRINGS ...]], --strings [STRINGS [STRINGS ...]]
                        list of strings to look for
```

### mem_find_handle
Find specific open handles in memory on Windows.

```
usage: mem_find_handle [-h] needle

positional arguments:
  needle      substring of the handle names to get

optional arguments:
  -h, --help  show this help message and exit
```

## OS

### os_services
List all services (Windows, launchctl on MacOS and initd on Linux).

```
usage: os_services [-h]

optional arguments:
  -h, --help  show this help message and exit
```

### os_drivers
List all drivers on Windows.

```
usage: os_drivers [-h]

optional arguments:
  -h, --help  show this help message and exit
```

### os_kill_process
Kill a process running on the sensor.

```
usage: os_kill_process [-h] [-p PID] [-a PROCESSATOM]

optional arguments:
  -h, --help            show this help message and exit
  -p PID, --pid PID     pid of the process to kill
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
```

### os_suspend
Suspend a process running on the sensor.

```
usage: os_suspend [-h] [-p PID] [-a PROCESSATOM] [-t TID]

optional arguments:
  -h, --help            show this help message and exit
  -p PID, --pid PID     process id
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
  -t TID, --tid TID     thread id
```

### os_resume
Resume execution of a process on the sensor.

```
usage: os_resume [-h] [-p PID] [-a PROCESSATOM] [-t TID]

optional arguments:
  -h, --help            show this help message and exit
  -p PID, --pid PID     process id
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
  -t TID, --tid TID     thread id
```

### os_processes
List all running processes on the sensor.

```
usage: os_processes [-h]

optional arguments:
  -h, --help  show this help message and exit
```

### os_autoruns
List pieces of code executing at startup, similar to SysInternals autoruns.

```
usage: os_autoruns [-h]

optional arguments:
  -h, --help  show this help message and exit
```

### os_version
Get detailed OS information on the sensor.

```
usage: os_version [-h]

optional arguments:
  -h, --help  show this help message and exit
```

## Registry

### reg_list
List the keys and values in a Windows registry key.

```
usage: reg_list [-h] reg

positional arguments:
  reg         registry path to list, must start with one of "hkcr", "hkcc", "hkcu", "hklm", "hku" like: "hklm\\software"...

optional arguments:
  -h, --help  show this help message and exit
```


## Anomalies

### hidden_module_scan
Look for hidden modules in a process' (or all) memory. Hidden modules are DLLs or dylibs loaded manually (not by the OS).

**Temporarily unavailable as we transition from the open source solution.**

```
usage: hidden_module_scan [-h] pid

positional arguments:
  pid         pid of the process to scan, or "-1" for ALL processes

optional arguments:
  -h, --help  show this help message and exit
```

### exec_oob_scan
Look for threads executing code outside bounds of known modules in memory. Various process injection methodologies.

**Temporarily unavailable as we transition from the open source solution.**

```
usage: exec_oob_scan [-h] pid

positional arguments:
  pid         pid of the process to scan, or "-1" for ALL processes

optional arguments:
  -h, --help  show this help message and exit
```

### hollowed_module_scan
Look for signs of process/module hollowing.

**Temporarily unavailable as we transition from the open source solution.**

```
usage: hollowed_module_scan [-h] pid

positional arguments:
  pid         pid of the process to scan

optional arguments:
  -h, --help  show this help message and exit
```

## Management

### exfil_add
Add an LC event to the list of events sent back to the backend by default.

```
usage: exfil_add [-h] -e EXPIRE event

positional arguments:
  event                 name of event to start exfiling

optional arguments:
  -h, --help            show this help message and exit
  -e EXPIRE, --expire EXPIRE
                        number of seconds before stopping exfil of event
```

### exfil_del
Remove an LC event from the list of events always sent back to the backend.

```
usage: exfil_del [-h] event

positional arguments:
  event       name of event to stop exfiling

optional arguments:
  -h, --help  show this help message and exit
```

### exfil_get
List all LC events sent back to the backend by default.

```
usage: exfil_get [-h]

optional arguments:
  -h, --help  show this help message and exit
```

### history_dump
Send to the backend the entire contents of the sensor event cache, so detailed events of everything that happenned recently.

```
usage: history_dump [-h] [-r ROOT] [-a ATOM] [-e EVENT]

optional arguments:
  -h, --help            show this help message and exit
  -r ROOT, --rootatom ROOT
                        dump events present in the tree rooted at this atom
  -a ATOM, --atom ATOM  dump the event with this specific atom
  -e EVENT, --event EVENT
                        dump events of this type only
```

### set_performance_mode
Turn on or off the high performance mode on a sensor. This mode is designed for very high performance servers requiring high
IO throughput. This mode reduces the accuracy of certain events which in turn reduces impact on the system. This mode is not
useful for the vast majority of hosts. If you are considering its usage, get in touch with the team at LimaCharlie.io.

```
usage: set_performance_mode [-h] [--is-enabled]

optional arguments:
  -h, --help    show this help message and exit
  --is-enabled  if specified, the high performance mode is enabled, otherwise
                disabled
```

## File (and Registry) Integrity Monitoring

### fim_add
Add a file or registry path pattern to monitor for modifications.
Patterns include basic wildcards:
* for one character: ?
* for at least one character: +
* for any number of characters: *
* escape character: \

Note that the pattern is not a string literal, therefore "\" needs to be escaped by one more level than usual.

So for example, you could do:
* `?:\\\\windows\\\\system32\\\\*.exe`
* `\\\\REGISTRY\\\\MACHINE\\\\SOFTWARE\\\\ActiveState\\\\*`

```
usage: fim_add [-h] --pattern PATTERNS

optional arguments:
  -h, --help          show this help message and exit
  --pattern PATTERNS  file path or registry path pattern to monitor
```

### fim_del
Remove a pattern from monitoring.

```
usage: fim_del [-h] --pattern PATTERNS

optional arguments:
  -h, --help          show this help message and exit
  --pattern PATTERNS  file path or registry path pattern to stop monitoring
```

### fim_get
Get the list of patterns being monitored.

```
usage: fim_get [-h]

optional arguments:
  -h, --help  show this help message and exit
```

## Yara

### yara_update
Update the compiled yara signature bundle that is being used for constant memory and file scanning on the sensor.

```
usage: yara_update [-h] rule

positional arguments:
  rule        rule to compile and set on sensor for contstant scanning, literal rule or "https://" URL or base64 encoded rule

optional arguments:
  -h, --help  show this help message and exit
```

### yara_scan
Scan for a specific yara signature in memory and files on the sensor.

**The memory component of the scan on MacOS may be less reliable due to recent limitations imposed by Apple.**

```
usage: yara_scan [-h] [-p PID] [-f FILEPATH] [-e PROC] rule

positional arguments:
  rule                  rule to compile and run on sensor, literal rule or "https://" URL or base64 encoded rule

optional arguments:
  -h, --help            show this help message and exit
  -p PID, --pid PID     pid of the process to scan
  -f FILEPATH, --filePath FILEPATH
                        path of the file to scan
  -e PROC, --processExpr PROC
                        expression to match on to scan (matches on full
                        process path)
```


## Documents

### doc_cache_get
Retrieve a document / file that was cached on the sensor.

Currently the types of documents cached cannot be changed (although it will be in the future):
* .bat
* .js
* .ps1
* .sh
* .py
* .exe
* .scr
* .pdf
* .doc
* .docm
* .docx
* .ppt
* .pptm
* .pptx
* .xlt
* .xlsm
* .xlsx
* .vbs
* .rtf
* .hta
* .lnk
* Any files created in `system32` on Windows.

```
usage: doc_cache_get [-h] [-f FILE_PATTERN] [-s HASHSTR]

optional arguments:
  -h, --help            show this help message and exit
  -f FILE_PATTERN, --file_pattern FILE_PATTERN
                        a pattern to match on the file path and name of the
                        document, simple wildcards ? and * are supported
  -s HASHSTR, --hash HASHSTR
                        hash of the document to get
```

## Mitigation

### deny_tree
Tells the sensor that all activity starting at a specific process (and its children) should be denied and killed. Great for ransomware mitigation.

```
usage: deny_tree [-h] atom [atom ...]

positional arguments:
  atom        atoms to deny from

optional arguments:
  -h, --help  show this help message and exit
```

### segregate_network
Tells the sensor to stop all network connectivity on the host except LC comms to the backend. So it's network isolation, great to stop lateral movement.

```
usage: segregate_network [-h]

optional arguments:
  -h, --help  show this help message and exit
```

### rejoin_network
Tells the sensor to allow network connectivity again (after it was segregated).

```
usage: rejoin_network [-h]

optional arguments:
  -h, --help  show this help message and exit
```
