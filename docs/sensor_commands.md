# Reference: Commands

The following is a reference list of all commands available to run on sensors. 

> For an overview of the mechanics of commands and how they're sent, read the [Sensor Commands](sensor-commands-overview.md) article first.

## Files and Directories

### file_get
Retrieve a file from the endpoint.

Platforms: Windows, Linux, MacOS

```
usage: file_get [-h] [-o OFFSET] [-s MAXSIZE] file

positional arguments:
  file                  file path to file to get

optional arguments:
  -o OFFSET, --offset OFFSET
                        offset bytes to begin reading the file at, in base 10
  -s MAXSIZE, --size MAXSIZE
                        maximum number of bytes to read, in base 10, max of
                        10MB
```

### file_info
Get file information, timestamps, sizes, etc.

Platforms: Windows, Linux, MacOS

```
usage: file_info [-h] file

positional arguments:
  file        file path to file to get info on

```

### dir_list
List the contents of a directory.

Platforms: Windows, Linux, MacOS

```
usage: dir_list [-h] [-d DEPTH] rootDir fileExp

positional arguments:
  rootDir               the root directory where to begin the listing from
  fileExp               a file name expression supporting basic wildcards like
                        * and ?

optional arguments:
  -d DEPTH, --depth DEPTH
                        optional maximum depth of the listing, defaults to a
                        single level
```

### dir_find_hash
Find files matching hashes starting at a root directory.

Platforms: Windows, Linux, MacOS

```
usage: dir_find_hash [-h] [-d DEPTH] --hash HASHES rootDir fileExp

positional arguments:
  rootDir               the root directory where to begin the search from
  fileExp               a file name expression supporting basic wildcards like
                        * and ?

optional arguments:
  -d DEPTH, --depth DEPTH
                        optional maximum depth of the listing, defaults to a
                        single level
  --hash HASHES         sha256 to search for, can be specified multiple times
```

### file_del
Delete a file from the endpoint.

Platforms: Windows, Linux, MacOS

```
usage: file_del [-h] file

positional arguments:
  file        file path to delete

```

### file_mov
Move / rename a file on the endpoint.

Platforms: Windows, Linux, MacOS

```
usage: file_mov [-h] srcFile dstFile

positional arguments:
  srcFile     source file path
  dstFile     destination file path

```

### file_hash
Compute the hash of a file.

Platforms: Windows, Linux, MacOS

```
usage: file_hash [-h] file

positional arguments:
  file        file path to hash

```

## Memory

### mem_map
Display the map of memory pages from a process including size, access rights, etc.

Platforms: Windows, Linux, MacOS

**Due to recent changes in MacOS, this may be less reliable on that platform.**

```
usage: mem_map [-h] [-p PID] [-a PROCESSATOM]

optional arguments:
  -p PID, --pid PID     pid of the process to get the map from
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target proces
```

### mem_read
Retrieve a chunk of memory from a process given a base address and size.

Platforms: Windows, Linux, MacOS

**Due to recent changes in MacOS, this may be less reliable on that platform.**

```
usage: mem_read [-h] [-p PID] [-a PROCESSATOM] baseAddr memSize

positional arguments:
  baseAddr              base address to read from, in HEX FORMAT
  memSize               number of bytes to read, in HEX FORMAT

optional arguments:
  -p PID, --pid PID     pid of the process to get the map from
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
```

### mem_handles
List all open handles from a process (or all) on Windows.

Platforms: Windows

```
usage: mem_handles [-h] [-p PID] [-a PROCESSATOM]

optional arguments:
  -p PID, --pid PID     pid of the process to get the handles from, 0 for all
                        processes
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
```

### mem_strings
List strings from a process's memory.

Platforms: Windows, Linux, MacOS

**Due to recent changes in MacOS, this may be less reliable on that platform.**

```
usage: mem_strings [-h] [-p PID] [-a PROCESSATOM]

optional arguments:
  -p PID, --pid PID     pid of the process to get the strings from
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
```


### mem_find_string
Find specific strings in memory.

Platforms: Windows, Linux, MacOS

**Due to recent changes in MacOS, this may be less reliable on that platform.**

```
usage: mem_find_string [-h] -s STRING [STRING ...] pid

positional arguments:
  pid                   pid of the process to search in, 0 for all processes

optional arguments:
  -s STRING [STRING ...], --strings STRING [STRING ...]
                        list of strings to look for
```

### mem_find_handle
Find specific open handles in memory on Windows.

Platforms: Windows

```
usage: mem_find_handle [-h] needle

positional arguments:
  needle      substring of the handle names to get

```

## OS

### os_services
List all services (Windows, launchctl on MacOS and initd on Linux).

Platforms: Windows, Linux, MacOS

```
usage: os_services [-h]

```

### os_drivers
List all drivers on Windows.

Platforms: Windows

```
usage: os_drivers [-h]

```

### os_packages
List installed software packages.

Platforms: Windows, Chrome

```
usage: os_packages [-h]

```

### os_kill_process
Kill a process running on the endpoint.

Platforms: Windows, Linux, MacOS

```
usage: os_kill_process [-h] [-p PID] [-a PROCESSATOM]

optional arguments:
  -p PID, --pid PID     pid of the process to kill
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
```

### os_suspend
Suspend a process running on the endpoint.

Platforms: Windows, Linux, MacOS

```
usage: os_suspend [-h] [-p PID] [-a PROCESSATOM] [-t TID]

optional arguments:
  -p PID, --pid PID     process id
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
  -t TID, --tid TID     thread id
```

### os_resume
Resume execution of a process on the endpoint.

Platforms: Windows, Linux, MacOS

```
usage: os_resume [-h] [-p PID] [-a PROCESSATOM] [-t TID]

optional arguments:
  -p PID, --pid PID     process id
  -a PROCESSATOM, --processatom PROCESSATOM
                        the atom of the target process
  -t TID, --tid TID     thread id
```

### os_processes
List all running processes on the endpoint.

Platforms: Windows, Linux, MacOS

```
usage: os_processes [-h] [-p PID] [--is-no-modules]

optional arguments:
  -p PID, --pid PID  only get information on process id
  --is-no-modules    do not report modules in processes
```

### os_autoruns
List pieces of code executing at startup, similar to SysInternals autoruns.

Platforms: Windows, Linux, MacOS

```
usage: os_autoruns [-h]

```

### os_version
Get detailed OS information on the endpoint.

Platforms: Windows, Linux, MacOS

```
usage: os_version [-h]

```

## Registry

### reg_list
List the keys and values in a Windows registry key.

Platforms: Windows

```
usage: reg_list [-h] reg

positional arguments:
  reg         registry path to list, must start with one of "hkcr", "hkcc", "hkcu", "hklm", "hku", e.g. "hklm\software"...

```


## Anomalies

### hidden_module_scan
Look for hidden modules in a process's (or all) memory. Hidden modules are DLLs or dylibs loaded manually (not by the OS).

Platforms: Windows

```
usage: hidden_module_scan [-h] pid

positional arguments:
  pid         pid of the process to scan, or "-1" for ALL processes

```


## Management

Note that instead of using the `exfil_add` and `exfil_del` commands directly it is recommended
to use [the Service](exfil.md) available through the web UI and REST interface.

### exfil_add
Add an LC event to the list of events sent back to the backend by default.

Platforms: Windows, Linux, MacOS

```
usage: exfil_add [-h] -e EXPIRE event

positional arguments:
  event                 name of event to start exfiling

optional arguments:
  -e EXPIRE, --expire EXPIRE
                        number of seconds before stopping exfil of event
```

### exfil_del
Remove an LC event from the list of events always sent back to the backend.

Platforms: Windows, Linux, MacOS

```
usage: exfil_del [-h] event

positional arguments:
  event       name of event to stop exfiling

```

### exfil_get
List all LC events sent back to the backend by default.

Platforms: Windows, Linux, MacOS

```
usage: exfil_get [-h]

```

### history_dump
Send to the backend the entire contents of the sensor event cache, i.e. detailed events of everything that happened recently.

Platforms: Windows, Linux, MacOS, Chrome

```
usage: history_dump [-h] [-r ROOT] [-a ATOM] [-e EVENT]

optional arguments:
  -r ROOT, --rootatom ROOT
                        dump events present in the tree rooted at this atom
  -a ATOM, --atom ATOM  dump the event with this specific atom
  -e EVENT, --event EVENT
                        dump events of this type only
```

### set_performance_mode
Turn on or off the high performance mode on a sensor. This mode is designed for very high performance servers requiring high
IO throughout. This mode reduces the accuracy of certain events which in turn reduces impact on the system. This mode is not
useful for the vast majority of hosts. If you are considering its usage, get in touch with the team at LimaCharlie.io.

Platforms: Windows

```
usage: set_performance_mode [-h] [--is-enabled]

optional arguments:
  --is-enabled  if specified, the high performance mode is enabled, otherwise
                disabled
```

### restart
The special command `restart` can be used to tell the LimaCharlie agent to re-initialize. This is typically only useful when
dealing with cloned sensor IDs in combination with the remote deletion of the identity file on disk.

### uninstall
Uninstall the sensor from that host.

Platform: Windows, MacOS

```
usage: uninstall [-h] [--is-confirmed]

optional arguments:
  --is-confirmed  must be specified as a confirmation you want to uninstall
                  the sensor
```

## File (and Registry) Integrity Monitoring

FIM rules are not persistent. This means that once an asset restarts, the rules
will be gone. The recommended way of managing rule application is to use
[Detection & Response rules](dr.md) in a similar way to managing [events to be
sent to the cloud](dr.md/#disable-an-event-at-the-source).

A sample D&R rule is available [here](dr.md/#monitoring-sensitive-directories).

Note that instead of using the `fim_add` and `fim_del` commands directly it is recommended
to use [the Service](integrity.md) available through the web UI and REST interface.

### fim_add
Add a file or registry path pattern to monitor for modifications.
Patterns include basic wildcards:

* for one character: `?`
* for at least one character: `+`
* for any number of characters: `*`
* escape character: `\`

Note that the pattern is not a string literal, therefore "\" needs to be escaped by one more level than usual.

So for example, you could do:

* `?:\*\Programs\Startup\*`
* `\REGISTRY\*\Microsoft\Windows\CurrentVersion\Run*`

Which would result in: `fim_add --pattern "?:\*\Programs\Startup\*" --pattern "\REGISTRY\*\Microsoft\Windows\CurrentVersion\Run*"`

Platforms: Windows, MacOS, Linux (see [this](replicants.md#linux) for notes on Linux support)

```
usage: fim_add [-h] --pattern PATTERNS

optional arguments:
  --pattern PATTERNS  file path or registry path pattern to monitor
```

### fim_del
Remove a pattern from monitoring.

Platforms: Windows, MacOS, Linux (see [this](replicants.md#linux) for notes on Linux support)

```
usage: fim_del [-h] --pattern PATTERNS

optional arguments:
  --pattern PATTERNS  file path or registry path pattern to stop monitoring
```

### fim_get
Get the list of patterns being monitored.

Platforms: Windows, MacOS, Linux (see [this](replicants.md#linux) for notes on Linux support)

```
usage: fim_get [-h]

```

## Yara

Note that instead of using the `yara_update` command directly it is recommended
to use [the Service](yara.md) available through the web UI and REST interface.

### yara_update
Update the compiled yara signature bundle that is being used for constant memory and file scanning on the sensor.

Platforms: Windows, Linux, MacOS

```
usage: yara_update [-h] rule

positional arguments:
  rule        rule to compile and set on sensor for constant scanning, literal rule or "https://" URL or base64 encoded rule
```

### yara_scan
Scan for a specific yara signature in memory and files on the endpoint.

Platforms: Windows, Linux, MacOS

**The memory component of the scan on MacOS may be less reliable due to recent limitations imposed by Apple.**

```
yara_scan [--pid PID] [--filePath FILEPATH] [--processExpr PROCESSEXPR] [--is-memory-only] [--is-no-validation] [--root-dir ROOT-DIR] [--file-exp FILE-EXP] [--depth DEPTH] RULE

Positional arguments:
  RULE                   rule to compile and run on sensor, Yara resource reference like "lcr://service/yara/my-source,other-source", literal rule or "https://" URL or base64 encoded rule

Options:
  --pid PID, -p PID      pid of the process to scan [default: -1]
  --filePath FILEPATH, -f FILEPATH
                         path to the file scan
  --processExpr PROCESSEXPR, -e PROCESSEXPR
                         expression to match on to scan (matches on full process path)
  --is-memory-only       only scan the memory, ignore files on disk. [default: true]
  --is-no-validation     if specified, do not validate the rule before sending. [default: false]
  --root-dir ROOT-DIR, -r ROOT-DIR
                         the root directory where to begin the search for files to scan
  --file-exp FILE-EXP, -x FILE-EXP
                         a file name expression supporting basic wildcards like * and ? to match against files in the --root-dir [default: *]
  --depth DEPTH, -d DEPTH
                         optional maximum depth of the search for files to scan, defaults to a single level
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

Platforms: Windows, MacOS

```
usage: doc_cache_get [-h] [-f FILE_PATTERN] [-s HASHSTR]

optional arguments:
  -f FILE_PATTERN, --file_pattern FILE_PATTERN
                        a pattern to match on the file path and name of the
                        document, simple wildcards ? and * are supported
  -s HASHSTR, --hash HASHSTR
                        hash of the document to get
```

## Mitigation

### deny_tree
Tells the sensor that all activity starting at a specific process (and its children) should be denied and killed. Great for ransomware mitigation.

Platforms: Windows, Linux, MacOS

```
usage: deny_tree [-h] atom [atom ...]

positional arguments:
  atom        atoms to deny from

```

### segregate_network
Tells the sensor to stop all network connectivity on the host except LC comms to the backend. So it's network isolation, great to stop lateral movement.

Note that you should never upgrade a sensor version while the network is isolated through this mechanism. Doing so may result in the agent not regaining
connectivity to the cloud, requiring a reboot to undo.

This command primitive is NOT persistent, meaning a sensor you segregate from the network using this command alone, upon reboot will rejoin the network.
To achieve isolation from the network in a persistent way, see the `isolate network` and `rejoin network` [D&R rule actions](dr.md#isolate-network).

Platforms: Windows, MacOS, Chrome

```
usage: segregate_network [-h]

```

### rejoin_network
Tells the sensor to allow network connectivity again (after it was segregated).

Platforms: Windows, MacOS, Chrome

```
usage: rejoin_network [-h]

```

## Network

### netstat

List network connections and sockets listening.

Platforms: Windows, Linux

```
usage: netstat [-h]

```

### dns_resolve
Cause the sensor to do a network resolution.
Mainly used for internal purposes.

Platforms: Windows, Linux, MacOS, Chrome

```
usage: dns_resolve [-h] domain

positional arguments:
  domain      domain name to resolve

```

## Artifact Collection

Note that instead of using the `artifact_get` command directly it is recommended
to use [the Service](external_logs.md) available through the web UI and REST interface.

### artifact_get
Retrieve an artifact from a sensor.

Platforms: Windows, Linux, MacOS

```
usage: artifact_get [-h] [--file FILE] [--source SOURCE] [--type TYPE]
                    [--payload-id PAYLOADID] [--days-retention RETENTION]
                    [--is-ignore-cert]

optional arguments:
  --file FILE           file path to get
  --source SOURCE       optional os specific artifact source (not currently supported)
  --type TYPE           optional artifact type
  --payload-id PAYLOADID
                        optional specifies an idempotent payload ID to use
  --days-retention RETENTION
                        number of days the data should be retained, default 30
  --is-ignore-cert      if specified, the sensor will ignore SSL cert mismatch
                        while upload the artifact
```

Note on usage scenarios for the `--is-ignore-cert` flag: If the sensor is deployed
on a host where built-in root CAs are not up to date or present at all, it may be
necessary to use the `--is-ignore-cert` flag to allow the logs to be pushed to the
cloud.

Unlike the main sensor transport (which uses a pinned certificate), the
Artifact Collection feature uses Google infrastructure and their public SSL certificates.

This may sometimes come up in unexpected ways. For example fresh Windows Server installations
do not have the root CAs for `google.com` enabled by default.

## Payloads

### run
Execute a payload or a shell command on the sensor.

Platforms: Windows, Linux, MacOS

```
usage: run [-h] [--payload-name NAME] [--arguments ARGUMENTS]
           [--shell-command SHELLCMD] [--timeout TIMEOUT] [--is-ignore-cert]

optional arguments:
  --payload-name NAME   name of the payload to run
  --arguments ARGUMENTS
                        arguments to run the payload with
  --shell-command SHELLCMD
                        shell command to run
  --timeout TIMEOUT     number of seconds to wait for payload termination
  --is-ignore-cert      if specified, the sensor will ignore SSL cert mismatch
                        while upload the log
  --interpreter INTERPRETER
                        specifies that the named payload should be executed with
                        a specific interpreter like "powershell"
```

Note on usage scenarios for the `--is-ignore-cert` flag: If the sensor is deployed
on a host where built-in root CAs are not up to date or present at all, it may be
necessary to use the `--is-ignore-cert` flag to allow the sensor to pull the payload to
execute from the cloud.

Unlike the main sensor transport (which uses a pinned certificate), the
Payloads feature uses Google infrastructure and their public SSL certificates.

This may sometimes come up in unexpected ways. For example fresh Windows Server installations
do not have the root CAs for `google.com` enabled by default.

### put
Upload a payload to an endpoint without executing it.

Platforms: Windows, Linux, MacOS

```
usage: put [-h] --payload-name NAME [--payload-path PATH] [--is-ignore-cert]

optional arguments:
  --payload-name NAME  name of the payload to run
  --payload-path PATH  path where to put the payload
  --is-ignore-cert     if specified, the sensor will ignore SSL cert mismatch
```

Note on usage scenarios for the `--is-ignore-cert` flag: If the sensor is deployed
on a host where built-in root CAs are not up to date or present at all, it may be
necessary to use the `--is-ignore-cert` flag to allow the sensor to pull the payload to
execute from the cloud.

Unlike the main sensor transport (which uses a pinned certificate), the
Payloads feature uses Google infrastructure and their public SSL certificates.

This may sometimes come up in unexpected ways. For example fresh Windows Server installations
do not have the root CAs for `google.com` enabled by default.

## Network Capture

### pcap_ifaces
List the network interfaces available for capture on a host.

## First Class Commands

### shutdown
Execute an immediate system shut down (no warnings and zero delay time)

Platforms: Linux, Mac, Windows

```
usage: shutdown --is-confirmed
```

### logoff
Execute a logoff for all the users

Platforms: Mac, Windows

```
usage: logoff --is-confirmed
```

### reboot
Execute an immediate system reboot (no warnings and zero delay time)

Platforms: Linux, Mac, Windows

```
usage: reboot --is-confirmed
```
