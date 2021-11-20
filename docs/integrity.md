# Integrity

## Overview
The integrity service helps you manage all aspects of File and Registry integrity monitoring.

Note that FIM configurations are synchronized with sensors every few minutes.

### Rules
Rules define which file path patterns and registry patterns should be monitored for changes for specific sets of hosts.

Filter tags are tags that must ALL be present on a sensor for it to match (AND condition), while the platform of the sensor must match one of the platforms in the filter (OR condition).

Patterns are file or registry patterns, supporting wildcards (*, ?, +). Windows directory separators (backslash, "\") must be escaped like "\\".

### Linux
FIM is partially supported on Linux. Specified file path expressions are actively monitored
via inotify (as opposed to MacOS and Windows where kernel passively monitors).

Due to inotify limitations, paths with wildcard are less efficient and only support
monitoring up to 20 sub-directories covered by the wildcard. In addition to this, the
path expressions should specify a final wildcard of `*` when all files under a directory
need to be monitored. Ommiting this `*` will result in only the directory itself being
monitored.

### REST

#### List Rules
```json
{
  "action": "list_rules"
}
```

#### Add Rule
```json
{
  "action": "add_rule",
  "name": "linux-root-ssh-configs",
  "patterns": [
    "/root/.ssh/*"
  ],
  "tags": [
    "vip",
    "workstation"
  ],
  "platforms": [
    "linux"
  ]
}
```

#### Remove Rule
```json
{
  "action": "remove_rule",
  "name": "linux-ssh-configs"
}
```