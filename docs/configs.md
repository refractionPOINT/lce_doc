# Configs

Configs are a YAML representation of an organization's configured features. This includes, but is not limited to, the following:

* Enabled Add-ons
* Detection & Response Rules
* Event / Artifact Collection Rules
* File / Integrity Monitoring Rules
* Outputs

The config makes it easy to reproduce setups across organizations, effectively turning organizations into containers for security environments.

## Example

Here's a basic config for an organization in LimaCharlie:

```yaml
version: 3
resources:
  api:
  - insight
  replicant:
  - infrastructure-service
  - integrity
  - reliable-tasking
  - responder
  - sigma
  - soteria-rules
  - logging
  - yara
integrity:
  linux-key:
    patterns:
    - /home/*/.ssh/*
    tags: []
    platforms:
    - linux
artifact:
  linux-logs:
    is_ignore_cert: false
    is_delete_after: false
    days_retention: 30
    patterns:
    - /var/log/syslog.1
    - /var/log/auth.log.1
    tags: []
    platforms:
    - linux
  windows-logs:
    is_ignore_cert: false
    is_delete_after: false
    days_retention: 30
    patterns:
    - wel://system:*
    - wel://security:*
    - wel://application:*
    tags: []
    platforms:
    - windows
```

Applying this would get an org started with some basics:

* Add-ons that enable incident response (`insight`, `reliable-tasking`, `responder`)
* Managed detection & response rulesets (`sigma`, `soteria-rules`)
* Services that add sensor capabilities (`integrity`, `logging`, `yara`)
* Some basic configurations to monitor file integrity of `*/.ssh` on Linux and collect syslog, auth logs, and Windows event logs

## Applying Configs

### Methods

* Via web application in 'Templates' (requires [`infrastructure-service`](https://app.limacharlie.io/add-ons/detail/infrastructure-service))
* Via REST API requests to [`infrastructure-service`](https://app.limacharlie.io/add-ons/detail/infrastructure-service)
* Via CLI ([`limacharlie config fetch`](https://github.com/refractionPOINT/python-limacharlie/#configs-1) / [`limacharlie config push`](https://github.com/refractionPOINT/python-limacharlie/#configs-1)) 

The web application offers two main modes of syncing:

* `Apply`: Add new config and apply changes additively
* `Modify`: Edit existing config and apply changes destructively

Apply mode can be especially useful for applying partial configs from online examples and community solutions. LimaCharlie has a [GitHub repository](https://github.com/refractionPOINT/templates) with some starter config templates.

> For finer-grained control of config, or updating configs as part of a CI pipeline, we recommend reading [`infrastructure-service`'s documentation](infrastructure-service.md). 
