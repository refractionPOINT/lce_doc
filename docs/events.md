# Reference: Events

The following is a reference list of all well-structured events available in LimaCharlie. 

> We recommend reading the [Events Overview](events-overview.md) to learn about the schema for events, if you haven't already.

## Sensor Events

Telemetry events from sensors, which D&R rules default to observing from the `edr` target.

> Note: there may be some variability between different sensor platforms.

### STARTING_UP
Event generated when the sensor starts.

Platforms: Windows, Linux, MacOS

```json
{
  "STARTING_UP": {
    "TIMESTAMP": 1455854079
  }
}
```

### SHUTTING_DOWN
Event generated when the sensor shuts down. Note: this event may not be observed if the
host shuts down abruptly or too quickly.

Platforms: Windows, Linux, MacOS

```json
{
  "SHUTTING_DOWN": {
    "TIMESTAMP": 1455674775
  }
}
```

### CONNECTED
Generated when sensor connects to cloud.

The `IS_SEGREGATED` flag signals whether the sensor is currently under network isolation.

Platforms: Windows, Linux, MacOS, Chrome

```json
{
  "IS_SEGREGATED" : 1
}
```

### DISCONNECTED
Generated when a sensor disconnects from the cloud.

Platforms: Windows, Linux, macOS, Chrome

```json
{}
```

### CLOUD_NOTIFICATION
This event is a receipt from the agent that it has received the task
sent to it, and includes high level errors (if any).

Platforms: Windows, Linux, MacOS

```json
{
  "NOTIFICATION_ID": "ADD_EXFIL_EVENT_REQ",
  "NOTIFICATION": {
    "INVESTIGATION_ID": "digger-4afdeb2b-a0d8-4a37-83b5-48996117998e"
  },
  "HCP_IDENT": {
    "HCP_ORG_ID": "c82e5c17d5194ef5a4acc454a95d31db",
    "HCP_SENSOR_ID": "8fc370e6699a49858e75c1316b725570",
    "HCP_INSTALLER_ID": "00000000000000000000000000000000",
    "HCP_ARCHITECTURE": 0,
    "HCP_PLATFORM": 0
  },
  "EXPIRY": 0
}
```

### RECEIPT
This event is used as a generic response to some commands. It usually
contains an `ERROR` code that you can use to determine if the command
was successful or not. It's often a good idea to issue the original command
with an `investigation_id` which will get echoed in the `RECEIPT` related
to that command to make it easier to track.

> To see all possible `ERROR` codes, visit the [Errors](errors.md) reference doc.

Platforms: Windows, Linux, MacOS, Chrome

### NEW_PROCESS
Generated when a new process starts.

Platforms: Windows, Linux, MacOS

```json
{
  "PARENT": {
    "PARENT_PROCESS_ID": 7076,
    "COMMAND_LINE": "\"C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\Common7\\IDE\\devenv.exe\"  ",
    "MEMORY_USAGE": 438730752,
    "PROCESS_ID": 5820,
    "THREADS": 39,
    "FILE_PATH": "C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\Common7\\IDE\\devenv.exe",
    "BASE_ADDRESS": 798949376
  },
  "PARENT_PROCESS_ID": 5820,
  "COMMAND_LINE": "-q  -s {0257E42D-7F05-42C4-B402-34C1CC2F2EAD} -p 5820",
  "FILE_PATH": "C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\VC\\vcpackages\\VCPkgSrv.exe",
  "PROCESS_ID": 1080,
  "THREADS": 9,
  "MEMORY_USAGE": 8282112,
  "TIMESTAMP": 1456285660,
  "BASE_ADDRESS": 4194304
}
```

### TERMINATE_PROCESS
Generated when a process exits.

Platforms: Windows, Linux, MacOS

```json
{
  "PARENT_PROCESS_ID": 5820,
  "TIMESTAMP": 1456285661,
  "PROCESS_ID": 6072
}
```

### PROCESS_ENVIRONMENT
Generated when a process starts. It lists all environment variables
associated with that new process.

Platforms: Windows, Linux

```json
{
  "ENVIRONMENT_VARIABLES": [
    "LANG=en_US.UTF-8",
    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    "NOTIFY_SOCKET=/run/systemd/notify",
    "LISTEN_PID=18950",
    "LISTEN_FDS=2",
    "LISTEN_FDNAMES=systemd-udevd-kernel.socket:systemd-udevd-control.socket",
    "WATCHDOG_PID=18950",
    "WATCHDOG_USEC=180000000",
    "INVOCATION_ID=07d6d5f06eea44cabd20adb6c6dcfe0c",
    "JOURNAL_STREAM=9:4165813"
  ],
  "PROCESS_ID": 13463
}
```

### WEL
Generated when a matching (Artifact Collection Rule) Windows Event Log is
seen on a Windows box.

Platforms: Windows

```json
{
  "EVENT": {
    "EventData": {
      "AuthenticationPackageName": "Negotiate",
      "ElevatedToken": "%%1842",
      "ImpersonationLevel": "%%1833",
      "IpAddress": "-",
      "IpPort": "-",
      "KeyLength": "0",
      "LmPackageName": "-",
      "LogonGuid": "{00000000-0000-0000-0000-000000000000}",
      "LogonProcessName": "Advapi",
      "LogonType": "5",
      "ProcessId": "0x290",
      "ProcessName": "C:\\Windows\\System32\\services.exe",
      "RestrictedAdminMode": "-",
      "SubjectDomainName": "WORKGROUP",
      "SubjectLogonId": "0x3e7",
      "SubjectUserName": "WIN-5KC7E0NG1OD$",
      "SubjectUserSid": "S-1-5-18",
      "TargetDomainName": "NT AUTHORITY",
      "TargetLinkedLogonId": "0x0",
      "TargetLogonId": "0x3e7",
      "TargetOutboundDomainName": "-",
      "TargetOutboundUserName": "-",
      "TargetUserName": "SYSTEM",
      "TargetUserSid": "S-1-5-18",
      "TransmittedServices": "-",
      "VirtualAccount": "%%1843",
      "WorkstationName": "-"
    },
    "System": {
      "Channel": "Security",
      "Computer": "WIN-5KC7E0NG1OD",
      "Correlation": {
        "ActivityID": "{cc484453-193e-0001-fe44-48cc3e19d701}"
      },
      "EventID": "4624",
      "_event_id": "4624",
      "EventRecordID": "42742",
      "Execution": {
        "ProcessID": "664",
        "ThreadID": "1080"
      },
      "Keywords": "0x8020000000000000",
      "Level": "0",
      "Opcode": "0",
      "Provider": {
        "Guid": "{54849625-5478-4994-a5ba-3e3b0328c30d}",
        "Name": "Microsoft-Windows-Security-Auditing"
      },
      "Security": "",
      "Task": "12544",
      "TimeCreated": {
        "SystemTime": "2021-03-17T00:41:45.3692165Z"
      },
      "Version": "2"
    }
  }
}
```

Note the presence of the `_event_id` field which is not part of the
original data. This field is a synthetic field that contains the simple
representation of the Event ID. This is due to the Windows Event Logs
representing the Event ID with multiple different structures that makes
writing rules more complicated.

### DNS_REQUEST
Generated from DNS responses and therefore includes both the
requested domain and the response from the server. If the server responds
with multiple responses (as allowed by the DNS protocol) the N answers will
become N DNS_REQUEST events, so you can always assume one DNS_REQUEST event
means one answer.

Platforms: Windows, MacOS, Chrome

```json
{
  "DNS_TYPE": 1,
  "TIMESTAMP": 1456285240,
  "DNS_FLAGS": 0,
  "DOMAIN_NAME": "time.windows.com"
}
```

### CODE_IDENTITY
Unique combinations of file hash and file path. Event is emitted the first time
the combination is seen. Therefore it's a great event to look for hashes without being
overwhelmed by process execution or module loads.

Platforms: Windows, Linux, MacOS

```json
{
  "MEMORY_SIZE": 0,
  "FILE_PATH": "C:\\Users\\dev\\AppData\\Local\\Temp\\B1B207E5-300E-434F-B4FE-A4816E6551BE\\dismhost.exe",
  "TIMESTAMP": 1456285265,
  "SIGNATURE": {
    "CERT_ISSUER": "C=US, S=Washington, L=Redmond, O=Microsoft Corporation, CN=Microsoft Code Signing PCA",
    "CERT_CHAIN_STATUS": 124,
    "FILE_PATH": "C:\\Users\\dev\\AppData\\Local\\Temp\\B1B207E5-300E-434F-B4FE-A4816E6551BE\\dismhost.exe",
    "CERT_SUBJECT": "C=US, S=Washington, L=Redmond, O=Microsoft Corporation, OU=MOPR, CN=Microsoft Corporation"
  },
  "HASH": "4ab4024eb555b2e4c54d378a846a847bd02f66ac54849bbce5a1c8b787f1d26c"
}
```

### NEW_TCP4_CONNECTION
Generated when a new TCPv4 connection is established, either inbound or outbound.

Platforms: Windows, Linux, MacOS

```json
{
  "PROCESS_ID": 6788,
  "DESTINATION": {
    "IP_ADDRESS": "172.16.223.219",
    "PORT": 80
  },
  "STATE": 5,
  "TIMESTAMP": 1468335512047,
  "SOURCE": {
    "IP_ADDRESS": "172.16.223.163",
    "PORT": 63581
  }
}
```

### NEW_UDP4_CONNECTION
Generated when a new UDPv4 socket "connection" is established, either inbound or outbound.

Platforms: Windows, Linux, MacOS

```json
{
  "TIMESTAMP": 1468335452828,
  "PROCESS_ID": 924,
  "IP_ADDRESS": "172.16.223.163",
  "PORT": 63057
}
```

### NEW_TCP6_CONNECTION
Generated when a new TCPv6 connection is established, either inbound or outbound.

Platforms: Windows, Linux, MacOS

### NEW_UDP6_CONNECTION
Generated when a new UDPv6 socket "connection" is established, either inbound or outbound.

Platforms: Windows, Linux, MacOS

### TERMINATE_TCP4_CONNECTION
Generated when a TCPv4 connection terminates.

```json
{
  "DESTINATION": {
    "IP_ADDRESS": "61.55.252.93",
    "PORT": 443
  },
  "PROCESS_ID": 4784,
  "SOURCE": {
    "IP_ADDRESS": "172.16.223.138",
    "PORT": 50145
  }
}
```

### TERMINATE_UDP4_CONNECTION
Generated when a UDPv4 socket terminates.

### TERMINATE_TCP6_CONNECTION
Generated when a TCPv6 connection terminates.

### TERMINATE_UDP6_CONNECTION
Generated when a UDPv6 socket terminates.

### NETWORK_CONNECTIONS
List of recent network connections performed by a process.

```json
{
  "NETWORK_ACTIVITY": [
    {
      "SOURCE": {
        "IP_ADDRESS": "172.16.223.138",
        "PORT": 50396
      },
      "IS_OUTGOING": 1,
      "DESTINATION": {
        "IP_ADDRESS": "23.214.49.56",
        "PORT": 80
      }
    },
    {
      "SOURCE": {
        "IP_ADDRESS": "172.16.223.138",
        "PORT": 50397
      },
      "IS_OUTGOING": 1,
      "DESTINATION": {
        "IP_ADDRESS": "189.247.166.18",
        "PORT": 80
      }
    },
    {
      "SOURCE": {
        "IP_ADDRESS": "172.16.223.138",
        "PORT": 50398
      },
      "IS_OUTGOING": 1,
      "DESTINATION": {
        "IP_ADDRESS": "23.217.70.67",
        "PORT": 80
      }
    },
    {
      "SOURCE": {
        "IP_ADDRESS": "172.16.223.138",
        "PORT": 50399
      },
      "IS_OUTGOING": 1,
      "DESTINATION": {
        "IP_ADDRESS": "104.110.238.53",
        "PORT": 80
      }
    },
    {
      "SOURCE": {
        "IP_ADDRESS": "172.16.223.138",
        "PORT": 50400
      },
      "IS_OUTGOING": 1,
      "DESTINATION": {
        "IP_ADDRESS": "23.214.49.56",
        "PORT": 80
      }
    },
    {
      "SOURCE": {
        "IP_ADDRESS": "172.16.223.138",
        "PORT": 50401
      },
      "IS_OUTGOING": 1,
      "DESTINATION": {
        "IP_ADDRESS": "204.79.197.203",
        "PORT": 80
      }
    }
  ],
  "HASH": "2de228cad2e542b2af2554d61fab5463ecbba3ff8349ba88c3e48637ed8086e9",
  "COMMAND_LINE": "C:\\WINDOWS\\system32\\msfeedssync.exe sync",
  "PROCESS_ID": 6968,
  "FILE_IS_SIGNED": 1,
  "USER_NAME": "WIN-5KC7E0NG1OD\\dev",
  "FILE_PATH": "C:\\WINDOWS\\system32\\msfeedssync.exe",
  "PARENT_PROCESS_ID": 1892
}
```

### HIDDEN_MODULE_DETECTED
Generated when the signature of an executable module is found in memory without
being known by the operating system.

Platforms: Windows

**Temporarily unavailable.**

### MODULE_LOAD
Generated when a module (like DLL on Windows) is loaded in a process.

Platforms: Windows, Linux, MacOS

```json
{
  "MEMORY_SIZE": 241664,
  "PROCESS_ID": 2904,
  "FILE_PATH": "C:\\Windows\\System32\\imm32.dll",
  "MODULE_NAME": "imm32.dll",
  "TIMESTAMP": 1468335264989,
  "BASE_ADDRESS": 140715814092800
}
```

### FILE_CREATE
Generated when a file is created.

Platforms: Windows, MacOS, Linux (eBPF)

```json
{
  "FILE_PATH": "C:\\Users\\dev\\AppData\\Local\\Microsoft\\Windows\\WebCache\\V01tmp.log",
  "TIMESTAMP": 1468335271948
}
```

### FILE_DELETE
Generated when a file is deleted.

Platforms: Windows, MacOS, Linux (eBPF)

```json
{
  "FILE_PATH": "C:\\Users\\dev\\AppData\\Local\\Temp\\EBA4E4F0-3020-459E-9E34-D5336E244F05\\api-ms-win-core-processthreads-l1-1-2.dll",
  "TIMESTAMP": 1468335611906
}
```

### NETWORK_SUMMARY
Generated either when a process exits or when a process has established 10 network
connections. This event combines process information with the first 10 network connections
it has done. It is a way to generate detections on process/network information without
sending home all network events all the time which is a lot of data.

***Deprecated, replaced by:*** `NETWORK_CONNECTIONS`

Platforms: Windows, Linux, MacOS

```json
{
  "PROCESS": {
    "PARENT": {
      "PARENT_PROCESS_ID": 876,
      "COMMAND_LINE": "C:\\WINDOWS\\system32\\compattelrunner.exe -maintenance",
      "MEMORY_USAGE": 3858432,
      "PROCESS_ID": 5164,
      "THREADS": 3,
      "FILE_PATH": "C:\\WINDOWS\\system32\\compattelrunner.exe",
      "BASE_ADDRESS": 140699034058752
    },
    "PARENT_PROCESS_ID": 5164,
    "COMMAND_LINE": "C:\\WINDOWS\\system32\\CompatTelRunner.exe -m:invagent.dll -f:RunUpdateW",
    "MEMORY_USAGE": 6668288,
    "PROCESS_ID": 652,
    "NETWORK_ACTIVITY": [
      {
        "DESTINATION": {
          "IP_ADDRESS": "65.55.252.190",
          "PORT": 443
        },
        "TIMESTAMP": 1456285233,
        "STATE": 5,
        "PROCESS_ID": 652,
        "SOURCE": {
          "IP_ADDRESS": "172.16.223.156",
          "PORT": 49724
        }
      },
      {
        "DESTINATION": {
          "IP_ADDRESS": "191.239.54.52",
          "PORT": 80
        },
        "TIMESTAMP": 1456285233,
        "STATE": 5,
        "PROCESS_ID": 652,
        "SOURCE": {
          "IP_ADDRESS": "172.16.223.156",
          "PORT": 49727
        }
      }
    ],
    "THREADS": 4,
    "FILE_PATH": "C:\\WINDOWS\\system32\\CompatTelRunner.exe",
    "TIMESTAMP": 1456285231,
    "BASE_ADDRESS": 140699034058752
  }
}
```

### FILE_GET_REP
Response from a file retrieval request.

Platforms: Windows, Linux, MacOS

### FILE_DEL_REP
Response from a file deletion request.

Platforms: Windows, Linux, MacOS

### FILE_MOV_REP
Response from a file move request.

Platforms: Windows, Linux, MacOS

### FILE_HASH_REP
Response from a file hash request.

Platforms: Windows, Linux, MacOS

### FILE_INFO_REP
Response from a file information request.

Platforms: Windows, Linux, MacOS

### DIR_LIST_REP
Response from a directory list request. Includes Alternate Data Streams on Windows.

Platforms: Windows, Linux, MacOS

```json
{
    "DIRECTORY_LIST": [
        {
            "FILE_NAME": "vssdk_full.exe",
            "CREATION_TIME": 1553437930012,
            "MODIFICATION_TIME": 1553437937000,
            "STREAMS": [
                {
                    "FILE_NAME": "::$DATA",
                    "SIZE": 13782032
                }
            ],
            "ACCESS_TIME": 1567868284440,
            "FILE_SIZE": 13782032,
            "ATTRIBUTES": 32,
            "FILE_PATH": "c:\\users\\dev\\desktop\\vssdk_full.exe"
        },
        {
            "FILE_NAME": "UniversalLog.txt",
            "CREATION_TIME": 1553028205525,
            "MODIFICATION_TIME": 1553028206289,
            "STREAMS": [
                {
                    "FILE_NAME": "::$DATA",
                    "SIZE": 125
                },
                {
                    "FILE_NAME": ":Zone.Identifier:$DATA",
                    "SIZE": 377
                }
            ],
            "ACCESS_TIME": 1567868284158,
            "FILE_SIZE": 125,
            "ATTRIBUTES": 32,
            "FILE_PATH": "c:\\users\\dev\\desktop\\UniversalLog.txt"
        }
    ]
}
```

### DIR_FINDHASH_REP
Response to a dir_find_hash request.

Platforms: Windows, Linux, MacOS

```json
{
    "DIRECTORY_LIST": [
        {
            "HASH": "f11dda931637a1a1bc614fc2f320326b24336c5155679aa062acae7c79f33d67",
            "ACCESS_TIME": 1535994794247,
            "FILE_SIZE": 113664,
            "CREATION_TIME": 1467173189067,
            "MODIFICATION_TIME": 1467173190171,
            "FILE_NAME": "MALWARE_DEMO_WINDOWS_1.exe",
            "ATTRIBUTES": 32,
            "FILE_PATH": "c:\\users\\dev\\desktop\\MALWARE_DEMO_WINDOWS_1.exe"
        },
        {
            "HASH": "e37726feee8e72f3ab006e023cb9d6fa1a4087274b47217d2462325fa8008515",
            "ACCESS_TIME": 1535989041078,
            "FILE_SIZE": 1016320,
            "CREATION_TIME": 1522507344821,
            "MODIFICATION_TIME": 1522507355732,
            "FILE_NAME": "lc_win_64.exe",
            "ATTRIBUTES": 32,
            "FILE_PATH": "c:\\users\\dev\\desktop\\lc_win_64.exe"
        }
    ],
    "HASH": [
        "f11dda931637a1a1bc614fc2f320326b24336c5155679aa062acae7c79f33d67",
        "e37726feee8e72f3ab006e023cb9d6fa1a4087274b47217d2462325fa8008515"
    ],
    "FILE_PATH": "*.exe",
    "DIRECTORY_LIST_DEPTH": 0,
    "DIRECTORY_PATH": "c:\\users\\dev\\desktop\\"
}
```

### MEM_MAP_REP
Response from a memory map request.

Platforms: Windows, Linux, MacOS

### MEM_READ_REP
Response from a memory read request.

Platforms: Windows, Linux, MacOS

### MEM_HANDLES_REP
Response from a list of memory handles request.

Platforms: Windows

### MEM_FIND_HANDLES_REP
Response from a find handles request.

Platforms: Windows

### MEM_STRINGS_REP
Response from a memory listing of strings request.

Platforms: Windows, Linux, MacOS

### MEM_FIND_STRING_REP
Response from a memory find string request.

Platforms: Windows, Linux, MacOS

### OS_SERVICES_REP
Response from a Services listing request.

Platforms: Windows, Linux, MacOS

```json
{
  "SVCS": [
    {
      "PROCESS_ID": 0,
      "SVC_TYPE": 32,
      "DLL": "%SystemRoot%\\System32\\AJRouter.dll",
      "SVC_NAME": "AJRouter",
      "SVC_STATE": 1,
      "HASH": "a09ae69c9de2f3765417f212453b6927c317a94801ae68fba6a8e8a7cb16ced7",
      "SVC_DISPLAY_NAME": "AllJoyn Router Service",
      "EXECUTABLE": "%SystemRoot%\\system32\\svchost.exe -k LocalService"
    },
    {
      "PROCESS_ID": 0,
      "SVC_TYPE": 16,
      "SVC_NAME": "ALG",
      "SVC_STATE": 1,
      "HASH": "f61055d581745023939c741cab3370074d1416bb5a0be0bd47642d5a75669e12",
      "SVC_DISPLAY_NAME": "Application Layer Gateway Service",
      "EXECUTABLE": "%SystemRoot%\\System32\\alg.exe"
    },
    { "..." : "..." }
  ]
}
```

### OS_DRIVERS_REP
Response from a Drivers listing request.

Platforms: Windows

```json
{
  "SVCS": [
    {
      "PROCESS_ID": 0,
      "SVC_TYPE": 1,
      "SVC_NAME": "1394ohci",
      "SVC_STATE": 1,
      "HASH": "9ecf6211ccd30273a23247e87c31b3a2acda623133cef6e9b3243463c0609c5f",
      "SVC_DISPLAY_NAME": "1394 OHCI Compliant Host Controller",
      "EXECUTABLE": "\\SystemRoot\\System32\\drivers\\1394ohci.sys"
    },
    {
      "PROCESS_ID": 0,
      "SVC_TYPE": 1,
      "SVC_NAME": "3ware",
      "SVC_STATE": 1,
      "SVC_DISPLAY_NAME": "3ware",
      "EXECUTABLE": "System32\\drivers\\3ware.sys"
    },
    { "..." : "..." }
  ]
}
```

### OS_KILL_PROCESS_REP
Response from a kill process request.

Platforms: Windows, Linux, MacOS

### OS_PROCESSES_REP
Response from a process listing request.

Platforms: Windows, Linux, MacOS

### OS_AUTORUNS_REP
Response from an Autoruns listing request.

Platforms: Windows, Linux, MacOS

```json
{
  "TIMESTAMP": 1456194620,
  "AUTORUNS": [
    {
      "REGISTRY_KEY": "Software\\Microsoft\\Windows\\CurrentVersion\\Run\\VMware User Process",
      "FILE_PATH": "\"C:\\Program Files\\VMware\\VMware Tools\\vmtoolsd.exe\" -n vmusr",
      "HASH": "036608644e3c282efaac49792a2bb2534df95e859e2ddc727cd5d2e764133d14"
    },
    {
      "REGISTRY_KEY": "SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Run\\RoccatTyonW",
      "FILE_PATH": "\"C:\\Program Files (x86)\\ROCCAT\\Tyon Mouse\\TyonMonitorW.EXE\"",
      "HASH": "7d601591625d41aecfb40b4fc770ff6d22094047216c4a3b22903405281e32e1"
    },
    { "..." : "..." }
  ]
}
```

### HISTORY_DUMP_REP
Response from history dump request. Does not itself contain the historic
events but will be generated along them.

Platforms: Windows, Linux, MacOS

### EXEC_OOB
Generated when an execution out of bounds (like a thread injection) is detected.

Platforms: Windows, Linux, MacOS

**Temporarily unavailable.**

```json
{
  "PARENT_PROCESS_ID": 660,
  "COMMAND_LINE": "\"C:\\Program Files\\WindowsApps\\Microsoft.Messaging_2.13.20000.0_x86__8wekyb3d8bbwe\\SkypeHost.exe\" -ServerName:SkypeHost.ServerServer",
  "MEMORY_USAGE": 8253440,
  "PROCESS_ID": 3904,
  "THREADS": 14,
  "FILE_PATH": "C:\\Program Files\\WindowsApps\\Microsoft.Messaging_2.13.20000.0_x86__8wekyb3d8bbwe\\SkypeHost.exe",
  "STACK_TRACES": [
    {
      "STACK_TRACE_FRAMES": [
        {
          "STACK_TRACE_FRAME_SP": 10483804,
          "STACK_TRACE_FRAME_PC": 1718227232,
          "STACK_TRACE_FRAME_FP": 10483796
        },
        {
          "STACK_TRACE_FRAME_SP": 10483812,
          "STACK_TRACE_FRAME_PC": 45029040433702885,
          "STACK_TRACE_FRAME_FP": 10483804
        },
        {
          "STACK_TRACE_FRAME_SP": 10483820,
          "STACK_TRACE_FRAME_PC": 4035225266123964416,
          "STACK_TRACE_FRAME_FP": 10483812
        }
      ],
      "THREAD_ID": 4708
    }
  ],
  "TIMESTAMP": 1456254033,
  "BASE_ADDRESS": 18415616
}
```

### MODULE_MEM_DISK_MISMATCH
Generated when a mismatch between the contents of memory and the expected module
on disk is found. Can be an indicator of process hollowing.

Platforms: Windows, Linux, MacOS

**Temporarily unavailable.**

### YARA_DETECTION
Generated when a YARA scan finds a match.

Platforms: Windows, Linux, MacOS

### SERVICE_CHANGE
Generated when a Service is changed.

Platforms: Windows, Linux, MacOS

```json
{
  "PROCESS_ID": 0,
  "SVC_TYPE": 32,
  "DLL": "%SystemRoot%\\system32\\wlidsvc.dll",
  "SVC_NAME": "wlidsvc",
  "SVC_STATE": 1,
  "HASH": "b37199495115ed423ba99b7317377ce865bb482d4e847861e871480ac49d4a84",
  "SVC_DISPLAY_NAME": "Microsoft Account Sign-in Assistant",
  "TIMESTAMP": 1467942600540,
  "EXECUTABLE": "%SystemRoot%\\system32\\svchost.exe -k netsvcs"
}
```

### DRIVER_CHANGE
Generated when a Driver is changed.

Platforms: Windows

```json
{
  "PROCESS_ID": 0,
  "SVC_DISPLAY_NAME": "HbsAcq",
  "SVC_NAME": "HbsAcq",
  "SVC_STATE": 1,
  "SVC_TYPE": 1,
  "TIMESTAMP": 1517377895873
}
```

### AUTORUN_CHANGE
Generated when an Autorun is changed.

Platforms: Windows, Linux, MacOS

### FILE_MODIFIED
Generated when a file is modified.

Platforms: Windows, MacOS, Linux (eBPF)

```json
{
  "FILE_PATH": "C:\\Users\\dev\\AppData\\Local\\Microsoft\\Windows\\WebCache\\V01.log",
  "TIMESTAMP": 1468335272949
}
```

### NEW_DOCUMENT
Generated when a file is created that matches a set list of locations and
extensions. It indicates the file has been cached in memory and can be retrieved
using the [doc_cache_get](sensor_commands.md) task.

The following file patterns are considered "documents":

* `.bat`
* `.js`
* `.ps1`
* `.sh`
* `.py`
* `.exe`
* `.scr`
* `.pdf`
* `.doc`
* `.docm`
* `.docx`
* `.ppt`
* `.pptm`
* `.pptx`
* `.xlt`
* `.xlsm`
* `.xlsx`
* `.vbs`
* `.rtf`
* `.hta`
* `.lnk`
* `.xsl`
* `.com`
* `.png`
* `.jpg`
* `.asp`
* `.aspx`
* `.php`
* `.jsp`
* `.jspx`
* `.html`
* `.htm`
* `.ocx`
* `\windows\system32\`

Platforms: Windows, MacOS

```json
{
  "FILE_PATH": "C:\\Users\\dev\\Desktop\\evil.exe",
  "TIMESTAMP": 1468335816308,
  "HASH": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
}
```

### GET_DOCUMENT_REP
Generated when a doc_cache_get task requests a cached document.

Platforms: Windows, MacOS

### USER_OBSERVED
Generated the first time a user is observed on a host.

Platforms: Windows, Linux, MacOS

```json
{
  "TIMESTAMP": 1479241363009,
  "USER_NAME": "root"
}
```

### FILE_TYPE_ACCESSED
Generated when a new process is observed interacting with certain
file types (like .doc). These can be used as indicators of an unknown
process exfiltrating files it should not, or ransom-ware.

This is the mapping between rule name ID and extensions:

* 1 = `.doc`
* 1 = `.docm`
* 1 = `.docx`
* 2 = `.xlt`
* 2 = `.xlsm`
* 2 = `.xlsx`
* 3 = `.ppt`
* 3 = `.pptm`
* 3 = `.pptx`
* 3 = `.ppts`
* 4 = `.pdf`
* 5 = `.rtf`
* 50 = `.zip`
* 51 = `.rar`
* 64 = `.locky`
* 64 = `.aesir`

Platforms: Windows, MacOS, Linux (eBPF)

```json
{
  "PROCESS_ID": 2048,
  "RULE_NAME": 3,
  "FILE_PATH": "C:\\Users\\dev\\Desktop\\importantnews.doc"
}
```

The `RULE_NAME` component is the class of file extension involved:

* Rule 1: `.doc`, `.docm`, `.docx`
* Rule 2: `.xlt`, `.xlsm`, `.xlsx`
* Rule 3: `.ppt`, `.pptm`, `.pptx`, `.ppts`
* Rule 4: `.pdf`
* Rule 5: `.rtf`
* Rule 50: `.zip`
* Rule 51: `.rar`
* Rule 64: `.locky`, `.aesir`

### NEW_REMOTE_THREAD
Generated on a Windows system when a thread is created by a process in another process.
This is a characteristic often used by malware during various forms of code injection.

In this case, the process id `492` created a thread (with id `9012`) in the process id `7944`.
The parent process is also globally uniquely identified by the `routing/parent` and the process
where the thread was started is globally uniquely identified by the `routing/target` (not visible here).

Platforms: Windows

```json
{
  "THREAD_ID": 9012,
  "PROCESS_ID": 7944,
  "PARENT_PROCESS_ID": 492
}
```

### OS_PACKAGES_REP
List of packages installed on the system. This is currently Windows only but will be
expanded to MacOS and Linux in the future. It is a response generated by
the `os_packages` command.

Platforms: Windows, Chrome

```json
"PACKAGES": [
  {
    "PACKAGE_NAME": "Microsoft Windows Driver Development Kit Uninstall - 3790.1830"
  },
  {
    "PACKAGE_VERSION": "1.1.40219",
    "PACKAGE_NAME": "Microsoft Help Viewer 1.1"
  },
  {
    "PACKAGE_VERSION": "10.0.40219",
    "PACKAGE_NAME": "Microsoft Team Foundation Server 2010 Object Model - ENU"
  },
  { "..." : "..." }
]
```

### REGISTRY_CREATE
This event is generated whenever a registry key / value is created on a Windows OS.

Platforms: Windows

```json
{
  "PROCESS_ID":  764,
  "REGISTRY_KEY":   "\\REGISTRY\\A\\{fddf4643-a007-4086-903e-be998801d0f7}\\Events\\{8fb5d848-23dc-498f-ac61-84b93aac1c33}"
}
```

### REGISTRY_DELETE
This event is generated whenever a registry key / value is deleted on a Windows OS.

Platforms: Windows

```json
{
  "PROCESS_ID":  764,
  "REGISTRY_KEY":   "\\REGISTRY\\A\\{fddf4643-a007-4086-903e-be998801d0f7}\\Events\\{8fb5d848-23dc-498f-ac61-84b93aac1c33}"
}
```

### REGISTRY_WRITE
This event is generated whenever a registry value is written to on a Windows OS.

The `REGISTRY_VALUE` contains the first 16 bytes of the value written to the registry.
If this value is a valid ASCII or Unicode string, the value will be as-is. On the other
hand if the value is binary data, it will be a base64 encoded string, see examples below.

The `SIZE` is the size value used in the original registry write call.
The `TYPE` is the Windows data type of the entry written as per [Microsoft's definition](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-rprn/25cce700-7fcf-4bb6-a2f3-0f6d08430a55).

Platforms: Windows

Valid string payload:
```json
{
  "PROCESS_ID":1820,
  "REGISTRY_KEY":"\\REGISTRY\\MACHINE\\SOFTWARE\\Microsoft\\Windows Defender\\Diagnostics\\LastKnownGoodPlatformLocation",
  "REGISTRY_VALUE":"C:\\Progr",
  "SIZE":1,
  "TYPE":1,
}
```

Binary payload:
```json
{
  "PROCESS_ID": 1700,
  "REGISTRY_KEY": "\\REGISTRY\\MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Diagnostics\\DiagTrack\\HeartBeats\\Default\\LastHeartBeatTime",
  "REGISTRY_VALUE": "bMPGjjDM1wE=",
  "SIZE": 11,
  "TYPE": 11
}
```

### REMOTE_PROCESS_HANDLE
This event is generated whenever a process opens a handle to another process with one
of the following access flags: `VM_READ`, `VM_WRITE` or `PROCESS_CREATE_THREAD`. Only
available on Windows OS. A `routing/target` is also populated in the event as the globally
unique identifier of the target process.

The `ACCESS_FLAGS` is the access mask as defined [here](https://docs.microsoft.com/en-us/windows/desktop/procthread/process-security-and-access-rights).

Platforms: Windows

```json
{
   "ACCESS_FLAGS":   136208,
   "PARENT_PROCESS_ID":  6492,
   "PROCESS_ID":   2516
}
```

### REGISTRY_LIST_REP
This event is generated in response to the `reg_list` command to list keys and values in a registry key.

Platforms: Windows

```json
{
    "REGISTRY_KEY": [
      "ActiveState",
      "ATI Technologies",
      "BreakPoint",
      "Caphyon",
      "Classes",
      "Clients",
      "Dell",
      "Google",
      "Intel",
      "Macromedia",
      "Microsoft",
      "MozillaPlugins",
      "ODBC",
      "OEM",
      "Partner",
      "Policies",
      "Rainbow Technologies",
      "RegisteredApplications",
      "SafeNet",
      "Sonic",
      "ThinPrint",
      "VMware, Inc.",
      "Volatile",
      "WinRAR",
      "WOW6432Node"
    ],
    "ROOT": "hklm\\software",
    "REGISTRY_VALUE": [
      {
        "TYPE": 4,
        "NAME": "Order",
        "VALUE": "32000000"
      }
    ],
    "ERROR": 0
}
```

### VOLUME_MOUNT
This event is generated when a volume is mounted.

Platforms: Windows, MacOS, Linux

```json
{
    "VOLUME_PATH": "E:",
    "DEVICE_NAME": "\\Device\\HarddiskVolume3"
}
```

### VOLUME_UNMOUNT
This event is generated when a volume is unmounted.

Platforms: Windows, MacOS, Linux

```json
{
    "VOLUME_PATH": "/Volumes/RECOVERY",
    "VOLUME_NAME": "/dev/disk2s1"
}
```

### FIM_LIST_REP
Listing of active [FIM](sensor_commands.md#file-and-registry-integrity-monitoring) entries.

Platforms: Windows, MacOS, Linux

```
{
  "PATTERNS": [
    "\\REGISTRY\\MACHINE\\SOFTWARE\\ActiveState\\*"
  ]
},
```

### FIM_HIT
A file, directory or registry key being monitored by [FIM](sensor_commands.md#file-and-registry-integrity-monitoring)
has been modified.

Platforms: Windows, MacOS, Linux

```json
{
  "PROCESS": {
    "MEMORY_USAGE": 25808896,
    "TIMESTAMP": 1541348299886,
    "COMMAND_LINE": "\"C:\\WINDOWS\\regedit.exe\" ",
    "THIS_ATOM": "9db1151f5c643e547110c3d57838316e",
    "PROCESS_ID": 4340,
    "THREADS": 3,
    "USER_NAME": "BUILTIN\\Administrators",
    "FILE_PATH": "C:\\WINDOWS\\regedit.exe",
    "BASE_ADDRESS": 140698122256384,
    "PARENT_PROCESS_ID": 6260
  },
  "REGISTRY_KEY": "\\REGISTRY\\MACHINE\\SOFTWARE\\ActiveState\\New Value #1",
  "PROCESS_ID": 4340
}
```

### NETSTAT_REP
This event is generated in response to the `netstat` command to list active network sockets.

Platforms: Windows, MacOS, Linux

###  THREAD_INJECTION
This event is generated when the sensor detects what looks like a thread injection into
a remote process.

Platforms: Windows

### SENSITIVE_PROCESS_ACCESS
This event is generated when a process gains sensitive access through a remote process handle or a remote thread to sensitive operating system processes like lsass.exe on Windows.

Platforms: Windows

```json
{
    "EVENTS": [
      {
        "event": {
          "BASE_ADDRESS": 140697066274816,
          "COMMAND_LINE": "C:\WINDOWS\system32\lsass.exe",
          "FILE_IS_SIGNED": 1,
          "FILE_PATH": "C:\WINDOWS\system32\lsass.exe",
          "HASH": "f56dddf7a8f1aa0f3d9ffe0cd618544cfaf233a33314240eccbe5f897a91b534",
          "MEMORY_USAGE": 14950400,
          "PARENT_PROCESS_ID": 484,
          "PROCESS_ID": 636,
          "THREADS": 12,
          "USER_NAME": "BUILTIN\Administrators"
        },
        "routing": {
          ...
        }
      },
      {
        "event": {
          "ACCESS_FLAGS": 2097151,
          "PARENT_PROCESS_ID": 4148,
          "PROCESS_ID": 636,
          "SOURCE": {
            "FILE_PATH": "\Device\HarddiskVolume1\ProgramData\Microsoft\Windows Defender\Platform\4.18.1902.2-0\MsMpEng.exe",
            "MEMORY_USAGE": 126771200,
            "PARENT_PROCESS_ID": 620,
            "PROCESS_ID": 4148,
            "THIS_ATOM": "69a5a90aade375d2860c76701ba8d701",
            "THREADS": 32,
            "TIMESTAMP": 1553448803541,
            "USER_NAME": "NT AUTHORITY\SYSTEM"
          },
          "TARGET": {
            "BASE_ADDRESS": 140697066274816,
            "COMMAND_LINE": "C:\WINDOWS\system32\lsass.exe",
            "FILE_PATH": "C:\WINDOWS\system32\lsass.exe",
            "MEMORY_USAGE": 14950400,
            "PARENT_PROCESS_ID": 484,
            "PROCESS_ID": 636,
            "THIS_ATOM": "98ffb0230c694f750671c7387b535b9b",
            "THREADS": 12,
            "TIMESTAMP": 1553448799838,
            "USER_NAME": "BUILTIN\Administrators"
          }
        },
        "routing": {
          ...
        }
      }
    ]
  }
```

### NEW_NAMED_PIPE
This event is emitted when a new Named Pipe is created by a process.

Platforms: Windows

### OPEN_NAMED_PIPE
This event is emitted when an existing Named Pipe is opened by a process.

Platforms: Windows

### DATA_DROPPED
This event is generated by the sensor when it has been offline and the events
generated overflowed its internal buffer before they could be sent to
the cloud, resulting in dropped events.

### HTTP_REQUEST
This event is emitted whenever an HTTP request is made.

Platforms: Chrome

```json
{
  "URL": "https://play.google.com/log?authuser=0",
  "IP_ADDRESS": "172.217.2.142",
  "RESULT": 200,
  "PARENT": {
    "URL": "https://console.cloud.google.com"
  }
}
```

## BROWSER_REQUEST_CONTEXT
Equivalent to New Process event.  Gets emitted on every HTTP request.  Allows a request to be related to its parent.

## EXISTING_PROCESS
This event is similar to the NEW_PROCESS event.  It gets emitted when a process existed prior to the LimaCharlie sensor loading.

## GET_EXFIL_EVENT_REP
Response from an exfil_get request.

## LOG_GET_REP
Response from an log_get request.

## LOG_LIST_REP
Response from an log_list request.

## OS_RESUME_REP
Response from an os_resume request.

## OS_SUSPEND_REP
Response from an os_suspend request.

## OS_VERSION_REP
Response from an os_version request.

## POSSIBLE_DOC_EXPLOIT
In-sensor stateful detection.  Looks for specific ancestor proceses (e.g. Word, Chrome, Firefox, etc.) spawning specific decendants (e.g. command.exe, ipconfig, etc.). As these relationships generally don't occur, they're considered suspect and this event is emitted.

**Temporarily unavailable.**

## RECON_BURST
In-sensor stateful detection.  A list of executables used during a recon phase of an attack (e.g. ipconfig, netstat, arp, route, traceroute, etc.); if >4 execute within 5 seconds, this event is emitted.

**Temporarily unavailable.**

## SELF_TEST_RESULT
Internal event used during a power-on-self-test (POST) of the sensor.


## ACK_MESSAGES
Acknowledge messages event is used by some LimaCharlie sensors (e.g. USP). It is not used by the EDR.

## BACKOFF
Used for flow control.  Provides a number of seconds that the sensor should wait before sending events to the cloud.

## DEBUG_DATA_REP
Response from a get_debug_data request.

## FIM_ADD
Add a new File Integrity Monitoring (FIM) rule interactively (e.g. via console command).

## FIM_REMOVE
Remove a new File Integrity Monitoring (FIM) rule interactively (e.g. via console command)

## HTTP_REQUEST_HEADERS
Provides HTTP Request headers.

Platforms: Chrome

## HTTP_RESPONSE_HEADERS
Provides HTTP Response headers.

Platforms: Chrome

## LATE_MODULE_LOAD
In-sensor stateful detection.  Looks for processes that have been running for >60 seconds which then spontaneously load a new module (e.g. DLL, Dylib).

**Temporarily unavailable.**

## LOG_ADD
**Temporarily unavailable.**

## LOG_REMOVE
**Temporarily unavailable.**

## NEW_RELATION
**Temporarily unavailable.**

## ONGOING_IDENTITY
Emits code identity signature information even when they are not newly seen.

## PCAP_LIST_INTERFACES_REP
Response from a pcap_ifaces request.

## REJOIN_NETWORK
Emitted after a sensor is allowed network connectivity again (after it was previously segregated).

## RUN
Emitted after a run command has been issued (e.g. to run a payload, shell command, etc.)

## SEGREGATE_NETWORK
Emitted when a sensor is segregated (isolated) from the network using the `segregate_network` command.

## SELF_TEST
Internal event to manually request a power-on-self-test (POST) from the sensor.

## SET_PERFORMANCE_MODE
Enables performance mode in the kernel (e.g. disables file tracking on Windows).

## SYNC
Internal event used as a heartbeat to the cloud.  Sent by default every 10 minutes.

## UNLOAD_KERNEL
Allows manual unloading of kernel component.

## UPDATE
Internal event used to update the configuration of a specific collector within the endpoint.

## YARA_RULES_UPDATE
Update the set of rules that are continuously scanned on the endpoint.

## YARA_SCAN
Run a specific YARA scan on the endpoint immediately.


## Deployment Events

Events around the global status of the deployment, observable in D&R rules via the `deployment` target.

### enrollment

Enrollment deployment events are produced when a sensor enrolls into the organization for the first time.

```json
{
  "routing": {
    "oid": "d9ae5c17-d519-4ef5-a4ac-c454a95d31ca",
    "iid": "ca812425-5a36-4c73-a0a0-935a8ace6451",
    "sid": "a75cc927-bf28-4178-a42d-25ecc8a6be81",
    "plat": 536870912,
    "arch": 2,
    "event_type": "enrollment",
    "event_time": 1561741553230
  },
  "event": {
    "public_ip": "104.196.34.101",
    "internal_ip": "172.17.0.2",
    "host_name": "linux-server-1"
  }
}
```

### sensor_clone

Sensor clone events are generated when the LimaCharlie Cloud detects that a specific Sensor ID may have been cloned.
Cloning means the same SID is associated with two different hosts at the same time. This is most often due to a machine image being created with a LC sensor installed on it, and then being deployed multiple times.

```json
{
  "routing": {
    "oid": "d9ae5c17-d519-4ef5-a4ac-c454a95d31ca",
    "iid": "ca812425-5a36-4c73-a0a0-935a8ace6451",
    "sid": "a75cc927-bf28-4178-a42d-25ecc8a6be81",
    "plat": 536870912,
    "arch": 2,
    "event_type": "sensor_clone",
    "event_time": 1561741553230
  },
  "event": {
    "previous_hostname" : "server-1",
    "new_hostname" : "server-2"
  }
}
```

### sensor_over_quota

Over quota deployment events are produced when a sensor tries to connect but the organization quota is already reached.

```json
{
  "routing": {
    "oid": "d9ae5c17-d519-4ef5-a4ac-c454a95d31ca",
    "iid": "ca812425-5a36-4c73-a0a0-935a8ace6451",
    "sid": "a75cc927-bf28-4178-a42d-25ecc8a6be81",
    "plat": 536870912,
    "arch": 2,
    "event_type": "sensor_over_quota",
    "event_time": 1561741553230
  },
  "event": {
    "public_ip": "104.196.34.101",
    "internal_ip": "172.17.0.2",
    "host_name": "linux-server-1"
  }
}
```

### deleted_sensor

Deleted Sensor deployment events are produced when a sensor that was previously deleted from an Org attempts to connect to the LimaCharlie cloud.

```json
{
  "routing": {
    "oid": "d9ae5c17-d519-4ef5-a4ac-c454a95d31ca",
    "iid": "ca812425-5a36-4c73-a0a0-935a8ace6451",
    "sid": "a75cc927-bf28-4178-a42d-25ecc8a6be81",
    "plat": 536870912,
    "arch": 2,
    "ext_ip": "104.196.34.101",
    "int_ip": "172.17.0.2",
    "hostname": "linux-server-1",
    "event_type": "deleted_sensor",
    "event_time": 1561741553230
  },
  "event": {
    "denied_for": "720h0m0s"
  }
}
```

### quota_changed

Quota changed events are emitted when the quota for an Organization changes.

```json
{
  "event":{
    "new_quota": 30,
    "old_quota": 25
  },
  "routing": {
    "event_time": 1644444297696,
    "event_type": "quota_changed",
    "oid": "8cbe27f4-aaaa-cccc-bbbb-138cd51389cd"
  }
}
```

### cloud_adapter_disabled

This event is emitted when a Cloud Adapter gets disabled because it has been erroring for a long period of time.

```json
{
  "event":{
    "error": "invalid api key"
  },
  "routing": {
    "event_time": 1644444297696,
    "event_type": "cloud_adapter_disabled",
    "oid": "8cbe27f4-aaaa-cccc-bbbb-138cd51389cd"
  }
}
```

### sensor_crash

This event is generated when a sensor has crashed. It will include some telemetry useful to help LimaCharlie
troubleshoot the crash.

```json
{
  "routing": {
    "arch": 2,
    "event_time": 1670861698000,
    "event_type": "sensor_crash",
    "hostname": "linux-server-1",
    "ext_ip": "104.196.34.101",
    "int_ip": "172.17.0.2",
    "oid": "8cbe27f4-aaaa-cccc-bbbb-138cd51389cd",
    "plat": 268435456,
    "iid": "ca812425-5a36-4c73-a0a0-935a8ace6451",
    "sid": "a75cc927-bf28-4178-a42d-25ecc8a6be81"
  },
  "event": {
    "crash_context": {
      "FILE_ID": 63,
      "LINE_NUMBER": 1216,
      "THREAD_ID": 7808
    }
  }
}
```

## Artifact Events

Events around artifact collection, observable in D&R rules via the `artifact_event` target.


### ingest

A new artifact has been ingested.

```json
{
    "routing" : {
        "log_id" : "ca812425-5a36-4c73-a0a0-935a8ace6451",
        "event_type" : "ingest",
        "log_type" : "pcap",
        "oid" : "ca812425-5a36-4c73-a0a0-935a8ace6451",
        "event_time" : 1561741553230,
    },
    "event" : {
        "size" : 2048,
        "source" : "a75cc927-bf28-4178-a42d-25ecc8a6be81",
        "original_path" : "/data/pcap/dat.pcap",
        "original_md5" : "adjfnwonefowrnfowef",
    },
}
```

### export_complete

An export of artifact data is completed and ready for download.

```json
{
    "routing" : {
        "log_id" : "ca812425-5a36-4c73-a0a0-935a8ace6451",
        "event_type" : "export_complete",
        "log_type" : "pcap",
        "oid" : "ca812425-5a36-4c73-a0a0-935a8ace6451",
        "event_time" : 1561741553230,
    },
    "event" : {
        "size" : 2048,
        "source" : "a75cc927-bf28-4178-a42d-25ecc8a6be81",
        "original_path" : "/data/pcap/dat.pcap",
        "export_id" : "d9ae5c17-d519-4ef5-a4ac-c454a95d31ca",
    },
}
```

## Schedule Events

Events triggered automatically at various intervals per organization or per sensor, observable in D&R rules via the `schedule` target.

Scheduling events have a very similar structure whether they are per-sensor or per-org.

The `event` component contains a single key, `frequency` which is the number of seconds frequency this scheduling event is for. The event
type also contains the human readable version of the frequency.

The following frequencies are currently emitted:
* `30m`: `30m_per_org` and `30m_per_sensor`
* `1h`: `1h_per_org` and `1h_per_sensor`
* `3h`: `3h_per_org` and `3h_per_sensor`
* `6h`: `6h_per_org` and `6h_per_sensor`
* `12h`: `12h_per_org` and `12h_per_sensor`
* `24h`: `24h_per_org` and `24h_per_sensor`
* `168h` (7 days): `168h_per_org` and `168h_per_sensor`

Scheduling events are generated for each org that meets the following criteria:
* Has had at least 1 sensor online in the last 7 days.

Scheduling events are generated for each sensor that meets the following criteria:
* Has been online at least once in the last 30 days.

Scheduling events are not retained as part of the year retention in LimaCharlie. To
leverage them, create D&R rules that target the `schedule` target and take the relevant
`action` when matched. For example to issue an `os_packages` once per week on Windows hosts:

```yaml
detect:
  target: schedule
  event: 168h_per_sensor
  op: is platform
  name: windows
respond:
  - action: task
    command: os_packages
    investigation: weekly-package-list
```

### *_per_org

Events that are emitted once per period per org. This allows you to schedule things at a global level.

```json
{
  "event": {
    "frequency": 86400
  },
  "routing": {
    "event_id": "0f236fbb-31df-4d11-b6ab-c6b71a63a072",
    "event_time": 1673298756512,
    "event_type": "1h_per_org",
    "oid": "8cbe27f4-bfa1-4afb-ba19-138cd51389cd",
    "sid": "00000000-0000-0000-0000-000000000000",
    "tags": []
  }
}
```

### *_per_sensor

Events that are emitted once per period per sensor. This allows you to schedule automation for each
sensor within an org.

```json
{
  "event": {
    "frequency": 1800
  },
  "routing": {
    "arch": 5,
    "did": "",
    "event_id": "247bbf44-5e60-41c3-9642-410447aa04d2",
    "event_time": 1673298757318,
    "event_type": "30m_per_sensor",
    "ext_ip": "34.82.75.115",
    "hostname": "prod-domain-controler",
    "iid": "ebda4de0-aaaa-aaaa-aaaa-698a5a10c3af",
    "int_ip": "192.168.10.2",
    "oid": "8cbe27f4-aaaa-aaaa-aaaa-138cd51389cd",
    "plat": 536870912,
    "sid": "640f2a6f-aaaa-aaaa-aaaa-dcc55726b450",
    "tags": [
      "prod",
      "domain",
    ]
  }
}
```