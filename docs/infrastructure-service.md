# Infrastructure Service

## Overview
The `infrastructure-service` service allows you to perform infrastructure-as-code modifications
to your tenant configuration without the use of the [Command Line Interface (CLI)](https://github.com/refractionPOINT/python-limacharlie/#configs-1).

The service offers the same parameters as the CLI through the generic Service Request section of the [web app](https://app.limacharlie.io).
A simplified UI is also available (once your tenant subscribes to the `infrastructure-service` add-on) under the "Templates" view. 

## Interacting
All interaction with this service mimics the [CLI tool](https://github.com/refractionPOINT/python-limacharlie/#configs-1).

Receiving feedback from the service (as to what modifications to the Org were required) requires using the `is_async: false` parameter (to receive the
feedback synchronously).

For security reasons, this service does not have the permissions to operate directly on your Org (therefore eliminating the possibility of a
user leveraging the service to elevate its access). This means the requester _must_ supply a `jwt: YOUR_JWT_VALUE` parameter which provides the
required permissions for the operations requested.

Given that this service runs in the cloud and not in a local file system, the actual configuration contents are provided using one of the following two methods:

### Method 1: Literal Configs

The `config` parameter specifies the literal content of the config to push. The format is the same YAML as normal config files, but the config
cannot contain any "includes", it must be final.

### Method 2: Authenticated Resource Locators (ARL)

The `config_source` and `config_root` must be specified and reference an [ARL](https://github.com/refractionPOINT/authenticated_resource_locator).

1. The `config_source` is the actual ARL describing where the config files are located, for example: `[github,refractionPOINT/mssp-demo/]`.
1. The `config_root` is the absolute (within the ARL) file path where the initial config file is located. This config file may "include" other config files relative to itself. For example: `/configs/customers/cus_2/main.yaml`.

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