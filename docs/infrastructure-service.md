# Infrastructure Service

## Overview
The `infrastructure-service` service allows you to perform infrastructure-as-code modifications
to your tenant configuration without the use of the [Command Line Interface (CLI)](https://github.com/refractionPOINT/python-limacharlie/#configs-1).

The service offers the same parameters as the CLI through the generic Service Request section of the [web app](https://app.limacharlie.io).
A simplified UI is also available (once your tenant subscribes to the `infrastructure-service` add-on) under a section called "Infrastructure Config". 

## Interacting
All interaction with this service mimicks the [CLI tool](https://github.com/refractionPOINT/python-limacharlie/#configs-1).

## REST

The REST interface mimicks the [CLI tool](https://github.com/refractionPOINT/python-limacharlie/#configs-1). Here is its usage information:

```json
{
  "params": {
    "sync_artifacts": {
      "type": "bool",
      "desc": "applies to artifacts"
    },
    "is_force": {
      "type": "bool",
      "desc": "make the org an exact copy of the configuration provided."
    },
    "is_dry_run": {
      "type": "bool",
      "desc": "do not apply config, just simulate."
    },
    "sync_integrity": {
      "type": "bool",
      "desc": "applies to integrity"
    },
    "sync_net_policies": {
      "type": "bool",
      "desc": "applies to net_policies"
    },
    "action": {
      "is_required": true,
      "values": [
        "push",
        "fetch"
      ],
      "type": "enum",
      "desc": "action to take."
    },
    "sync_org_values": {
      "type": "bool",
      "desc": "applies to org_values"
    },
    "sync_resources": {
      "type": "bool",
      "desc": "applies to resources"
    },
    "config": {
      "type": "str",
      "desc": "configuration to apply."
    },
    "config_source": {
      "type": "str",
      "desc": "ARL where configs to apply are located."
    },
    "ignore_inaccessible": {
      "desc": "ignore resources which are inaccessible like locked or segmented.",
      "type": "bool"
    },
    "sync_fp": {
      "type": "bool",
      "desc": "applies to fp"
    },
    "sync_exfil": {
      "desc": "applies to exfil",
      "type": "bool"
    },
    "sync_dr": {
      "type": "bool",
      "desc": "applies to dr"
    },
    "sync_outputs": {
      "type": "bool",
      "desc": "applies to outputs"
    },
    "config_root": {
      "type": "str",
      "desc": "file name of the root config within config_source to apply."
    }
  }
}
```