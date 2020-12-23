# Net

Limacharlie Net allows you to secure and monitor network access to your endpoints by providing a advanced instrumented VPN access.

Net endpoints appear like other endpoints in your LimaCharlie deployment, but they're quite different in nature. These Net endpoints need to be provisioned to be accessed.

By provisioning a Net endpoint, you create a set of VPN credentials that can be used by a device. One set of credentials should be use by no more than 1 device.

Once connected, these devices will be able to connect to the internet by default. Connectivity and additional features that can be enabled by Net are defined using "policies".

The underlying technology used for VPN is called [WireGuard](https://www.wireguard.com/). WireGuard is an next-gen VPN technology that is promoted for its simplicity, speed and security.

Clients are available for [Windows, Android, macOS, iOS and ChromeOS](https://www.wireguard.com/install/). Client configuration is done either through a QR code or a simple configuration file.

## Provisioning

### CLI
Using the [LimaCharlie CLI](https://github.com/refractionPOINT/python-limacharlie/) (`pip install limacharlie`), you can provising new clients one at a time or in batches.

Provisioning is done in the context of an installation key, just like an host based endpoint.

The command line to use is:

```
$ limacharlie net client provision
usage: limacharlie net client provision [-h] [--name NAMES [NAMES ...]]
                                        [--name-file NAMEFILE]
                                        [--output OUTPUT] [--email-user]
                                        iid

positional arguments:
  iid                   installation key id

optional arguments:
  -h, --help            show this help message and exit
  --name NAMES [NAMES ...]
                        client name (hostname or email)
  --name-file NAMEFILE  file containing newline-separated names to provision
  --output OUTPUT       output directory where to put new config files, or "-"
                        for stdout
  --email-user          if set, limacharlie will email users creds directly
```

The `name` is the name that will be associated with the Net device. We recommend using a user identifier like an email address. In fact, if you use an email address, you can specify the `--email-user` flag and the QR code + configuration file will be emailed directly to the `name` (email address).

The `--name-file` option allows you to specify a file containing all the names to provision.

The `--output` can be used to send the configuration files directly to a directory.

## Policies

### Firewall

### Service

### Capture