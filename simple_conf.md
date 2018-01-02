# Simple Configuration

The simple configuration mechanism is designed to provide a YAML based, simple, humand readable configuration file
format that can be used for a two main purposes:

1. Add configurations to the LCE backend without mucking with the REST or RPC interface.
2. Have a human readable backup/restore file for core configurations that can be version controlled.

## Basic Operation

The simple configuration is provided by the `./simpleconf.py` script. This script takes an `--interface` like most other
appliance operation scripts, but it also requires one of `--load` or `--save` where load takes a config file and applies
it to the appliance's backend and save takes the current backend configuration and writes it to a file.

Generally speaking, any configuration specified in the config file will be applied on top of whatever is configured in the
backend. This means a configuration file can be a subset of all the available configuration parameters. The save command
however will always save all available backend configurations to one file.

*Note that the `simpleconf.py` operates on the database directly. Since most components cache configurations for a
certain amount of time, you may have to wait, for reload components in order for the changes to take effect.*

## Sample File

Below is a sample config file showing the general format. We will focus on specific aspects of the file on the next sections.

```yaml
# This is a sample config file that can be loaded into an LCE backend.
# The 00000000-0000-0000-0000-000000000000 values will be replaced with new UUIDs.
primary: 127.0.0.1
primary_port: 443
secondary: 127.0.0.1
secondary_port: 443

# The location of the sensor packages.
sensor_package: https://github.com/refractionPOINT/limacharlie/releases/download/3.7.0.1/lc_sensor_3.7.0.1.zip

# The credentials to send automated emails from D&R rules.
paging:
    user: autoemail@mycomp.com
    from: noreply@mycomp.com
    password: abcdef12345
    smtp_server: smtp.gmail.com
    smtp_port: 587

# This is a secret value used to "sign" enrollment of sensors. Keep it secret, long and random, like a UUID.
enrollment_secret: 00000000-0000-0000-0000-000000000000

# Root key signing all sensor modules.
root_key:
    pub: .....
    pri: .....

# TLS key encrypting comms between sensors and backend.
c2_key:
    pub: ..... 
    pri: .....

# Organizations to create / update.
orgs:
    00000000-0000-0000-0000-000000000000:
        name: test_org
        # The maximum number of sensors concurently online for this organization.
        sensor_quota: 500

        # The installation keys to create / update.
        installation_keys:
            00000000-0000-0000-0000-000000000000:
                key: .....
                # Tags applied by default to the sensors using this key.
                tags:
                    - vip
                    - executives
                desc: installation key for executives
        # Encryption key used specifically by this organization.
        hbs_key:
            pub: .....
            pri: .....

        # The output modules active for this organization, where is sent to.
        outputs:
            test_out_events:
                for: event
                module: file
                dir: /tmp/lc_out_event/
            test_out_detecs:
                for: detect
                module: file
                dir: /tmp/lc_out_detect/

```

## Backup / Restore Strategy

Because config files can be partial, it means we can do something like this:

1. Configure backend until it is to our liking, whether through config files, RPCs or REST.
2. Use `./simpleconf.py --save backup.yaml` to save the current state to a file.
3. Validate that all configurations are as we want them.
4. Split the `backup.yaml` file into multiple files:
  * One for global configurations, root and c2 keys etc.
  * One for each organization in the `orgs:` part of the config file.
5. Backup or store in a repository those config files.

This has the advantage of being a set of files that can be applied individually to update / restore certain organization
configurations. It makes each organization config file much easier to manage and understand.

