***[Back to documentation root](README.md)***

# Collectors

Sensor capabilities are grouped by components called Collectors. Each Collector will generally provide a single or small suite
of capabilities. Collectors can be enabled and disabled individually through the use of [Profiles](profiles.md). All collectors
are not necessarily available on all platforms.

For a description of the actual events generated from those collectors, see the [events listing](events.md).

## List of Collectors

### Collector 0: Exfil

#### Characteristics
* Profile Reference: `HbsCollectorId.EXFIL`
* Platforms: All

#### Description
This core collector is required for all platforms at all times. It regulates the local caching of events and the forwarding
of other events to the cloud. If disabled the sensor will stop sending any events to the cloud.


### Collector 1: Process Tracker

#### Characteristics
* Profile Reference: `HbsCollectorId.PROCESS_TRACKER`
* Platforms: All

#### Description
This collector is responsible to track the creation and termination of all processes. It
generates `NEW_PROCESS`, `TERMINATE_PROCESS` and `EXISTING_PROCESS` events. Since many other collectors rely on those
events to accomplish their job it's highly recommended it be enabled.


### Collector 2: DNS Tracker

#### Characteristics
* Profile Reference: `HbsCollectorId.DNS_TRACKER`
* Platforms: Windows and MacOS

#### Description
This collector tracks all DNS requests/responses made by the system and reports them. It generates the `DNS_REQUEST` event.


### Collector 3: Code Identity

#### Characteristics
* Profile Reference: `HbsCollectorId.CODE_IDENTITY`
* Platforms: All

#### Description
This collector manages the identifying of various pieces of code loading on the system. It checks the hash of any file
loaded or executed and emits one of two events:
1. If it is the first time the combination of the hash and code location (usually a file) is observed, a `CODE_IDENTITY`
event is generated. This means that to get de-duplicated events containing all hashes observed on a host the subscribing to
the `CODE_IDENTITY` event will accomplish that.
2. If the combination has been observed before, an `ONGOING_IDENTITY` event is generated instead. Subscribing to those events
generates ***significantly*** more traffic from your sensors.


### Collector 4: Network Tracker

#### Characteristics
* Profile Reference: `HbsCollectorId.NETWORK_TRACKER`
* Platforms: All

#### Description
This collector tracks network connections to and from the host. Every connection generates a new event of the type `NEW_<PROTOCOL>_CONNECTION`.
This can generate a lot of events so beware, you likely want the output from the Network Summary collector described below.


### Collector 5: Hidden Module

#### Characteristics
* Profile Reference: `HbsCollectorId.HIDDEN_MODULE`
* Platforms: All

#### Description
This collector continually (and on demand via a sensor task) scans memory of the processes running on the host. It looks
for signs of a code module (for example a DLL on Windows) loaded in memory without the Operating System being aware of it.
If it finds such a module it generates a `HIDDEN_MODULE_DETECTED` event.


### Collector 6: Module Tracker

#### Characteristics
* Profile Reference: `HbsCollectorId.MODULE_TRACKER`
* Platforms: All

#### Description
This collector tracks the loading and unloading of modules (like DLL on Windows) on the host and generates `MODULE_LOAD` events.


### Collector 7: File Tracker

#### Characteristics
* Profile Reference: `HbsCollectorId.FILE_TRACKER`
* Platforms: Windows and MacOS

#### Description
This collector tracks the File System operations. It generates events of type `FILE_CREATE`, `FILE_DELETE`, `FILE_MODIFIED` and `FILE_READ`.


### Collector 8: Network Summary

#### Characteristics
* Profile Reference: `HbsCollectorId.NETWORK_SUMMARY`
* Platforms: All

#### Description
This collector produces summaries of network activity in an attempt to provide base visibility into new process activity
without having to send to the cloud all network connection events. To do this, the collector creates a summary for each
process executing which contains the first N network connections the process has made. When the limit N is reached, or
the process terminates, the summary is posted as a `NETWORK_SUMMARY` event.


### Collector 9: File Forensics

#### Characteristics
* Profile Reference: `HbsCollectorId.FILE_FORENSICS`
* Platforms: All

#### Description
This collector provides basic file operations (move, delete, get, hash and info).


### Collector 10: Memory Forensics

#### Characteristics
* Profile Reference: `HbsCollectorId.MEMORY_FORENSICS`
* Platforms: All

#### Description
This collector provides basic memory access functionality (memory map, read memory, handles, strings).


### Collector 11: OS Forensics

#### Characteristics
* Profile Reference: `HbsCollectorId.OS_FORENSICS`
* Platforms: All

#### Description
This collector provides basic OS level listings (services, drivers, autoruns, os info) and operations (kill/suspend/resume process).


### Collector 13: Execution Out of Bounds

#### Characteristics
* Profile Reference: `HbsCollectorId.EXEC_OOB`
* Platforms: Windows

#### Description
This collector continuously scans (and on demand via a sensor task) the process space of all processes. It looks for signs of
code execution out of known bounds. This means a thread executing outside of known module code which could indicate some
forms of code injections. When detected it emits an `EXEC_OOB` event.


### Collector 14: Deny Tree

#### Characteristics
* Profile Reference: `HbsCollectorId.DENY_TREE`
* Platforms: All

#### Description
This collector is responsible for terminating execution of activity rooted at a specific source (like a process). This is used
to apply mitigation to a process that is deemed to have been compromised.


### Collector 15: Process Hollowing

#### Characteristics
* Profile Reference: `HbsCollectorId.PROCESS_HOLLOWING`
* Platforms: All

#### Description
This collector continuously scans (and on demand via a sensor task) memory looking for mismatches between modules loaded
in memory and their expected content from disk. When a mismatch is found it can indicate that process / module hollowing
has occured and a `MODULE_MEM_DISK_MISMATCH` event is generated.


### Collector 16: Yara

#### Characteristics
* Profile Reference: `HbsCollectorId.YARA`
* Platforms: All

#### Description
This collector continuously scans (and on demand via a sensot task) the memory and files of processes and modules loaded
on the host. For more details on Yara see [this link](https://virustotal.github.io/yara/).


### Collector 17: OS Tracker

#### Characteristics
* Profile Reference: `HbsCollectorId.OS_TRACKER`
* Platforms: All

#### Description
This collector tracks changes to the listings generated by the OS Forensics collector and generates events like `SERVICE_CHANGE`.


### Collector 18: Doc Cache

#### Characteristics
* Profile Reference: `HbsCollectorId.DOC_CACHE`
* Platforms: All

#### Description
This collector monitors the creation of files using profile-supplied file path patterns and when one is created, the collector
keeps an in-memory copy of the file and emits a `NEW_DOCUMENT` event with some basic information on the file cached. The 
cloud can then optionally request the complete file from the sensor cache.


### Collector 19: Volume Tracker

#### Characteristics
* Profile Reference: `HbsCollectorId.VOLUME_TRACKER`
* Platforms: All

#### Description
This collector monitors volumes being mounted and unmounted on the host and generates the relevant
`VOLUME_MOUNT` and `VOLUME_UNMOUNT` events.


### Collector 20: Stateful Tracking

#### Characteristics
* Profile Reference: `HbsCollectorId.STATEFUL_TRACKING`
* Platforms: All

#### Description
This collector performs advanced state tracking for in-sensor D&R rules.


### Collector 21: User Tracker

#### Characteristics
* Profile Reference: `HbsCollectorId.USER_TRACKER`
* Platforms: All

#### Description
This collector reports when a new user is observed on a host through the `USER_OBSERVED` event. This is useful in
conjunction with dynamic sensor tagging to dynamically apply D&R rules to specific users (VIPs for example).


### Collector 22: File Type Tracker

#### Characteristics
* Profile Reference: `HbsCollectorId.FILE_TYPE_TRACKER`
* Platforms: All

#### Description
This collector characterises processes accessing certain file types/path patterns. The first time a process accesses
a file matching a profile-specified pattern category, a `FILE_TYPE_ACCESSED` event is generated with the process and
file information. This can be useful to efficiently detect processes not expected to access sensitive data for example.
