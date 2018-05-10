# Events

[TOC]

Below is a list of all the events available in LC along with a sample output. Please note that there may be some variability between platforms.

## Common Information

Some common elements to events are worth pointing out.

* routing/this is a UUID generated for every event in the sensor.
* routing/parent is a reference to the parent event's routing/this, providing strong relationships (much more reliable than simple process IDs)
between the events. This allows you to get the extremely powerful explorer view.
* routing/event_time is the time (UTC) the sensor produced the event.

## Events Listing

### STARTING_UP
Event generated when the sensor starts.
```json
{
  "STARTING_UP": {
    "TIMESTAMP": 1455854079
  }
}
```

### SHUTTING_DOWN
Event generated when the sensor shuts down, may not be observed if the
host shuts down too quickly or abruptly.

```json
{
  "SHUTTING_DOWN": {
    "TIMESTAMP": 1455674775
  }
}
```

### CONNECTED
Generated when sensor connects to cloud.

### NEW_PROCESS
Generated when a new process starts.

```json
{
  "NEW_PROCESS": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
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
}
```

### TERMINATE_PROCESS
Generated when a process exits.

```json
{
  "TERMINATE_PROCESS": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "PARENT_PROCESS_ID": 5820, 
    "TIMESTAMP": 1456285661, 
    "PROCESS_ID": 6072
  }
}
```

### DNS_REQUEST
Generated from DNS responses and therefore includes both the
requested domain and the response from the server. If the server responds
with multiple responses as allowed by the DNS protocol, the N answers will
become N DNS_REQUEST events, so you can always assume one DNS_REQUEST event
means one answer.

```json
{
  "DNS_REQUEST": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "DNS_TYPE": 1, 
    "TIMESTAMP": 1456285240, 
    "DNS_FLAGS": 0, 
    "DOMAIN_NAME": "time.windows.com"
  }
}
```

### CODE_IDENTITY
Unique combinations of file hash and file path. Event is emitted the first time
the combination is seen. Therefore it's a great event to look for hashes without being
overwhelmed by process execution or module loads.

```json
{
  "CODE_IDENTITY": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
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
}
```

### NEW_TCP4_CONNECTION
Generated when a new TCPv4 connection is established, either inbound or outbound.

```json
{
  "NEW_TCP4_CONNECTION": {
    "PROCESS_ID": 6788, 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "DESTINATION": {
      "IP_ADDRESS": "172.16.223.219", 
      "PORT": 80
    }, 
    "STATE": 5, 
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "TIMESTAMP": 1468335512047, 
    "SOURCE": {
      "IP_ADDRESS": "172.16.223.163", 
      "PORT": 63581
    }
  }
}
```

### NEW_UDP4_CONNECTION
Generated when a new UDPv4 socket "connection" is established, either inbound or outbound.

```json
{
  "NEW_UDP4_CONNECTION": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "TIMESTAMP": 1468335452828, 
    "PROCESS_ID": 924, 
    "IP_ADDRESS": "172.16.223.163", 
    "PORT": 63057
  }
}
```

### HIDDEN_MODULE_DETECTED
Generated when the signature of an executable module is found in memory without
being known by the operating system.

### MODULE_LOAD
Generated when a module (like DLL on Windows) is loaded in a process.

```json
{
  "MODULE_LOAD": {
    "MEMORY_SIZE": 241664, 
    "PROCESS_ID": 2904, 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "FILE_PATH": "C:\\Windows\\System32\\imm32.dll", 
    "MODULE_NAME": "imm32.dll", 
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "TIMESTAMP": 1468335264989, 
    "BASE_ADDRESS": 140715814092800
  }
}
```

### FILE_CREATE
Generated when a file is created.

```json
{
  "FILE_CREATE": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "FILE_PATH": "C:\\Users\\dev\\AppData\\Local\\Microsoft\\Windows\\WebCache\\V01tmp.log", 
    "TIMESTAMP": 1468335271948
  }
}
```

### FILE_DELETE
Generated when a file is deleted.

```json
{
  "FILE_DELETE": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "FILE_PATH": "C:\\Users\\dev\\AppData\\Local\\Temp\\EBA4E4F0-3020-459E-9E34-D5336E244F05\\api-ms-win-core-processthreads-l1-1-2.dll", 
    "TIMESTAMP": 1468335611906
  }
}
```

### NETWORK_SUMMARY
Generated either when a process exits or when a process has established 10 network
connections. This event combines process information with the first 10 network connections
it has done. It is a way to generated detections on process/network information without
sending home all network events all the time which is a lot of data.

```json
{
  "NETWORK_SUMMARY": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
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

### FILE_DEL_REP
Response from a file deletion request.

### FILE_MOV_REP
Response from a file move request.

### FILE_HASH_REP
Response from a file hash request.

### FILE_INFO_REP
Response from a file information request.

### DIR_LIST_REP
Response from a directory list request.

### MEM_MAP_REP
Response from a memory map request.

### MEM_READ_REP
Response from a memory read request.

### MEM_HANDLES_REP
Response from a list of memory handles request.

### MEM_FIND_HANDLES_REP
Response from a find handles request.

### MEM_STRINGS_REP
Response from a memory listing of strings request.

### MEM_FIND_STRING_REP
Response from a memory find string request.

### OS_SERVICES_REP
Response from a Services listing request.

```json
{
  "OS_SERVICES_REP": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
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

```json
{
  "OS_DRIVERS_REP": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
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

### OS_PROCESSES_REP
Response from a process listing request.

### OS_AUTORUNS_REP
Response from an Autoruns listing request.

```json
{
  "OS_AUTORUNS_REP": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
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

### EXEC_OOB
Generated when an execution out of bounds (like a thread injection) is detected.

```json
{
  "EXEC_OOB": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
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
}
```

### MODULE_MEM_DISK_MISMATCH
Generated when a mismatch between the contents of memory and the expected module
on disk is found, can be an indicator of process hollowing.

### YARA_DETECTION
Generated when a Yara scan finds a match.

### SERVICE_CHANGE
Generated when a Service is changed.

```json
{
  "SERVICE_CHANGE": {
    "PROCESS_ID": 0, 
    "SVC_TYPE": 32, 
    "DLL": "%SystemRoot%\\system32\\wlidsvc.dll", 
    "SVC_NAME": "wlidsvc", 
    "SVC_STATE": 1, 
    "HASH": "b37199495115ed423ba99b7317377ce865bb482d4e847861e871480ac49d4a84", 
    "SVC_DISPLAY_NAME": "Microsoft Account Sign-in Assistant", 
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "TIMESTAMP": 1467942600540, 
    "EXECUTABLE": "%SystemRoot%\\system32\\svchost.exe -k netsvcs"
  }
}
```

### DRIVER_CHANGE
Generated when a Driver is changed.

```json
{
  "DRIVER_CHANGE": {
    "PROCESS_ID": 0,
    "SVC_DISPLAY_NAME": "HbsAcq",
    "SVC_NAME": "HbsAcq",
    "SVC_STATE": 1,
    "SVC_TYPE": 1,
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8f",
    "TIMESTAMP": 1517377895873
  }
}
```

### AUTORUN_CHANGE
Generated when an Autorun is changed.

### FILE_MODIFIED
Generated when a file is modified.

```json
{
  "FILE_MODIFIED": {
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "FILE_PATH": "C:\\Users\\dev\\AppData\\Local\\Microsoft\\Windows\\WebCache\\V01.log", 
    "TIMESTAMP": 1468335272949
  }
}
```

### NEW_DOCUMENT
Generated when a file is created that matches a set list of locations and
extensions. It indicates the file has been cached in memory and can be retrieved
using the [doc_cache_get](sensor_commands.md) task.

```json
{
  "NEW_DOCUMENT": {
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "FILE_PATH": "C:\\Users\\dev\\Desktop\\New Text Document.txt", 
    "TIMESTAMP": 1468335816308, 
    "HASH": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  }
}
```

### GET_DOCUMENT_REP
Generated when a doc_cache_get task requrested a cached document.

### USER_OBSERVED

```json
{
  "USER_OBSERVED": {
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "TIMESTAMP": 1479241363009, 
    "USER_NAME": "root"
  }
}
```

### FILE_TYPE_ACCESSED
Generated when a new process is observed interacting with certain
file types (like .doc). These can be used as indicators of an unknown
process exfiltrating files it should not.

```json
{
  "FILE_TYPE_ACCESSED": {
    "PARENT_ATOM": "e7c2dcfb-1da4-88ad-a20c-6447a31bbeca", 
    "THIS_ATOM": "d9db23be-c938-7140-70fe-d74c6c9ce7d8", 
    "PROCESS_ID": 2048,
    "RULE_NAME": 3,
    "FILE_PATH": "C:\\Users\\dev\\Desktop\\importantnews.doc"
  }
}
```