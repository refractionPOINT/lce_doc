# Sensor Cull

## Overview
The `sensor-cull` service performs continuous cleaning of old sensors that have not
connected to your organization in a number of days.

This is useful for environments with cloud deployments or VM template based deployments
that enroll sensors over and over.

## Interacting
The sensor-cull service does not implement a web UI, but because of its simplicity all
interactions, like managing rules can be done via the generic Service Request section
of the web interface.

The service works by creating rules that describe when various sensors should be
cleaned up.

Each rule specifies a single sensor `tag` used as a selector for the sensors the rule applies to.
A rule also has a `name` (simply used for your bookkeeping), and a `ttl` which is the number of
days a sensor can not connect to the cloud before it becomes eligible for cleanup.

Cleanup is automatically applied once a day.

## REST

### get_rules

```
{
  "action": "get_rules"
}
```

Simply get the list of existing rules.

### run

```
{
  "action": "run"
}
```

Do a cleanup right now.

### add_rule

```
{
  "action": "add_rule",
  "name": "my new rule",
  "tag": "vip",
  "ttl": 30
}
```

Create a rule named "my new rule" that applies to all sensors with the "vip"
tag and cleans them up when they haven't connected in 30 days.

### del_rule

```
{
  "action": "get_rules",
  "name": "my new rule"
}
```

Delete an existing rule by name.
