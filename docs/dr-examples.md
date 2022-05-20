# Examples: Detection & Response Rules


## Translating Existing Rules

Before listing examples, it's worth mentioning [uncoder.io](https://uncoder.io/) by [SOC Prime](https://socprime.com/) is a great resource for learning by analogy. If you're already familiar with another platform for rules or search queries (Sigma, Splunk, Kibana, etc.) you can use uncoder to translate to LimaCharlie's D&R rules. 


## Examples

Note that through limacharlie.io, in order to provide an easier to edit format, the same rule configuration is used but is in YAML format instead. For example:

```yaml
# Detection
op: ends with
event: NEW_PROCESS
path: event/FILE_PATH
value: .scr

# Response
- action: report
  name: susp_screensaver
- action: add tag
  tag: uses_screensaver
  ttl: 80000
```

### WanaCry
Simple WanaCry detection and mitigation rule:

```yaml
# Detection
op: ends with
event: NEW_PROCESS
path: event/FILE_PATH
value: wanadecryptor.exe
case sensitive: false

# Response
- action: report
  name: wanacry
- action: task
  command: history_dump
- action: task
  command: 
    - deny_tree
    - <<routing/this>>
```


### Classify Users
Tag any sensor where the CEO logs in with "vip".

```yaml
# Detection
op: is
event: USER_OBSERVED
path: event/USER_NAME
value: stevejobs
case sensitive: false

# Response
- action: add tag
  tag: vip
```

### Suspicious Windows Executable Names
```yaml
# Detection
event: CODE_IDENTITY
op: matches
path: event/FILE_PATH
case sensitive: false
re: .*((\\.txt)|(\\.doc.?)|(\\.ppt.?)|(\\.xls.?)|(\\.zip)|(\\.rar)|(\\.rtf)|(\\.jpg)|(\\.gif)|(\\.pdf)|(\\.wmi)|(\\.avi)|( {5}.*))\\.exe
```

### Disable an Event at the Source
Turn off the sending of a specific event to the cloud. Useful to limit some verbose data sources when not needed.

```yaml
# Detection
op: is windows
event: CONNECTED

# Response
- action: task
  command: exfil_del NEW_DOCUMENT
```

### Monitoring Sensitive Directories
Make sure the File Integrity Monitoring of some directories is enabled whenever Windows sensors connect.

```yaml
# Detection
event: CONNECTED
op: is windows

# Response
- action: task
  command: fim_add --pattern 'C:\*\Programs\Startup\*' --pattern '\REGISTRY\*\Microsoft\Windows\CurrentVersion\Run*'
```

### Mention of an Internal Resource
Look for references to private URLs in proxy logs.

```yaml
# Detection
target: artifact
op: contains
path: /text
value: /corp/private/info

# Response
- action: report
  name: web-proxy-private-url
```

### De-duplicate Cloned Sensors
Sometimes users install a sensor on a VM image by mistake. This means every time a new instance of the image gets started the same sensor ID (SID) is used for multiple boxes with different names. When detected, LimaCharlie produces a [sensor_clone](events.md#sensor_clone) event.

We can use these events to deduplicate. This example targets Windows clones.

```yaml
# Detection
target: deployment
event: sensor_clone
op: is windows

# Response
- action: task
  command: file_del %windir%\system32\hcp.dat
- action: task
  command: file_del %windir%\system32\hcp_hbs.dat
- action: task
  command: file_del %windir%\system32\hcp_conf.dat
- action: task
  command: restart
```
