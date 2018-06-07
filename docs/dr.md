# Detection and Response

[TOC]

Detect lambdas are designed to allow you to push out a detection rule and with a custom action in record time.
Think of it like a `lambda` in various programming languages or in AWS. They can be added and removed with single operations
and they become immediately available/running as they are set. 

A D&R rule has two components:
* the Detection part of the rule is a simple expression that describes what the rule should match on.
* the response part of the rule describes the list of actions that should be taken when the rule matches.

The REST interface expects those rules in their native JSON format (as descrbed below), but UIs to generate this
format will be available if you are uncomfortable with the JSON.

For more sample rules and guidelines around rule-writing, see our public repository dedicated to this purpose
[here](https://github.com/refractionPOINT/rules).

The website version (on limacharlie.io) of this takes the rules as YAML to make it easier to visualize.

## Detection Component
Each logical operation in this component is a dictionary with an `op` field. Complex logical evaluation is done
by using two special `op` values, `and` and `or`. These will take a `rules` parameter that is a list of other logical
operations to perform.

Here is a basic example of a rule that says:
When we receive a `STARTING_UP` event from a linux sensor, and this sensor has the tag `test_tag`, match.

```json
{ 
    "op": "and", 
    "rules" : [
        {
            "op": "is linux",
            "event": "STARTING_UP"
        },
        {
            "op" : "is tagged",
            "tag": "test_tag"
        }
    ]
}
```

The `"event": "SOME_EVENT_NAME"` pattern can be used in all logical nodes to filter the event type of the event being
evaluated. You can also use an `"events": [ "EVENT_ONE", "EVENT_THREE"]` to filter for the event being one of the types
in the list. When a detection is generated (through the `report` action), it gets fed back into D&R rules with an `event_type`
of `_DETECTIONNAME`. This can be used to compose higher order detections.

### Logical Operations
Some parameters are available to all logical operations.
* `"not": true`: will reverse the matching outcome of an operations.
* `"case sensitive": false`: will turn all string-based evaluations to ignore case.

A recurring parameter also found in many operations is the `"path": <>` parameter. It represents a path within the event
being evaluated that we want the value of. Its structure is very close to a directory structure. It also supports the
`*` wildcard to represent 0 or many number of directories as well as the `?` wildcard that represents exactly one directory.

The root of the path should be `event` or `routing` depending on whether you want to get a value from the event itself or
the routing instead.

Note that many comparison values support a special "lookback" format. That is, an operation that supports comparing 
a value to a literal like `"system32"`, can also support a value of `"<<event/PARENT/FILE_PATH>>"`. When that value is 
surrounded by `"<<"` and `">>"`, the value located in between will be interpreted as a path within the event and the
value at that path will replace the `"<<...>>"` value. This allows you to "look back" at the event and use values
within for your rule.

For example, this sample JSON event:
```json
{
    "USER_ID": 501, 
    "PARENT": {
        "USER_ID": 501, 
        "COMMAND_LINE": "/Applications/Sublime Text.app/Contents/MacOS/plugin_host 71954", 
        "PROCESS_ID": 71955, 
        "USER_NAME": "maxime", 
        "FILE_PATH": "/Applications/Sublime Text.app/Contents/MacOS/plugin_host", 
        "PARENT_PROCESS_ID": 71954,
        "DEEP_HASH": {
            "HASH_VALUE": "ufs8f8hfinsfd9sfdsf"
        }
    }, 
    "PROCESS_ID": 23819, 
    "FILE_PATH": "/Applications/Xcode.app/Contents/Developer/usr/bin/git", 
    "PARENT_PROCESS_ID": 71955
}
```

The following paths with their result element:
* `event/USER_ID` results in `501`
* `event/?/USER_NAME` results in `"maxime"`
* `event/PARENT/PROCESS_ID` results in `71955`
* `event/*/HASH_VALUE` results in `ufs8f8hfinsfd9sfdsf`

#### and, or
The standard logical boolean operations to combine other logical operations. Take a single `"rules" : []` parameter
with the logical operations to apply the boolean logic to.

#### is
Tests for equality between the value of the `"value": <>` parameter and the value found in the event at the `"path": <>`
parameter.

Example:
```json
{
    "op": "is",
    "path": "event/PARENT/PROCESS_ID",
    "value": 9999
}
```

#### contains, ends with, starts with
The `contains` checks for a substring match, `starts with` checks for a prefix match and `ends with` checks for a suffix
match.

They all use the `path` and `value` parameters.

#### matches
The `matches` op compares the value at `path` with a regular expression supplied in the `re` parameter.

Example:
```json
{
    "op": "matches",
    "path": "event/FILE_PATH",
    "re": ".*\\\\system32\\\\.*\\.scr",
    "case sensitive": false
}
```

#### is windows, is linux, is mac, is 32 bit, is 64 bit
All of these operators take no additional arguments, they simply match if the relevant sensor characteristic is
correct.

#### is tagged
Determines if the tag supplied in the `tag` parameter is already associated with the sensor the event under evaluation
is from.

#### lookup
Looks up a value against a LimaCharlie Resource like a threat feed. The value is supplied via the `path` parameter and
the resource path is defined in the `resource` parameter. Resources are of the form `lcr://<resource_type>/<resource_name>`.
In order to access a resource you must have subscribed to it via `app.limacharlie.io`.

Example:
```json
{
    "op": "lookup",
    "path": "event/DOMAIN_NAME",
    "resource": "lcr://lookup/malwaredomains",
    "case sensitive": false
}
```

#### external
Use an external detection rule loaded from a LimaCharlie Resource. The resource is specified via the `resource` parameter.
Resources are of the form `lcr://<resource_type>/<resource_name>`, the `external` operation only supports Resources of
type `detection`. The external detection replaces the current detection rule, which means it can be combined with other
detection logic using the `and` and `or` operations.

Example:
```json
{
    "op": "external",
    "resource": "lcr://detection/suspicious-windows-exec-location"
}
```

## Response Component
The response component is simpler as it does not have the boolean logic concept. It is simply a list of actions to take
when the Detection component matches.

The action type is specified in the `action` parameter.

### Actions
Possible actions are:

#### task
This action sends the task (as described [here](sensor_commands.md)) in the `command` parameter to the sensor the event
under evaluation is from.

Example:
```json
{
    "action": "task",
    "command": "history_dump"
}
```

#### report
Reports the match as a detection. This means that the content of this event will be bubbled up to the Detection Output
stream. Think of it as an alert. It takes a `name` parameter that will be used as a detection category and a `publish`
parameter that, if set to `false` means the report won't be published to the Output stream.

This last distinction about the `publish` parameter is important because the detections created by the `report` action
get feed back into the D&R rules so that more complex rules may handle more complex evaluations of those. Setting the
`publish` to `false` means that this detection is only really used as an intermediary and should not be reported in and
of itself. When fed back, the `event_type` is set to `_DETECTIONNAME`.

#### add tag, remove tag
These two actions associate and disassociate the tag found in the `tag` parameter with the sensor.

Example:
```json
{
    "action": "add tag",
    "tag": "vip"
}
```

## Putting it Together

Note that through limacharlie.io, in order to provide an easier to edit format, the same rule configuration
is used but is in YAML format instead, like this:
**Detect:**
```yaml
op: ends with
event: NEW_PROCESS
path: event/FILE_PATH
value: .scr
```

**Respond:**
```yaml
- action: report
  name: susp_screensaver
- action: add tag
  tag: uses_screensaver
  ttl: 80000
```

### WanaCry
Simple WanaCry detection and mitigation rule:

**Detect**
```json
{
    "op": "ends with",
    "event": "NEW_PROCESS",
    "path": "event/FILE_PATH",
    "value": "@wanadecryptor@.exe",
    "case sensitive": false
}
```

**Respond**
```json
[
    {
        "action": "report",
        "name": "wanacry"
    },
    {
        "action": "task",
        "command": "history_dump"
    },
    {
        "action": "task",
        "command": [ "deny_tree", "<<routing/this>>" ]
    }
]
```


### Classify Users
Tag any sensor where the CEO logs in with "vip".

**Detect**
```json
{
    "op": "is",
    "event": "USER_OBSERVED",
    "path": "event/USER_NAME",
    "value": "stevejobs",
    "case sensitive": false
}
```

**Respond**
```json
[
    {
        "action": "add tag",
        "tag": "vip"
    }
]
```

### Suspicious Windows Executable Names
```json
{
    "op": "matches",
    "path": "event/FILE_PATH",
    "case sensitive": false,
    "re": ".*((\\.txt)|(\\.doc.?)|(\\.ppt.?)|(\\.xls.?)|(\\.zip)|(\\.rar)|(\\.rtf)|(\\.jpg)|(\\.gif)|(\\.pdf)|(\\.wmi)|(\\.avi)|( {5}.*))\\.exe"
}
```