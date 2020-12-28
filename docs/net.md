# Net

LimaCharlie Net (lc-net) allows you to secure and monitor network access to your endpoints by providing advanced instrumented VPN access.

lc-net endpoints appear like other endpoints in your LimaCharlie deployment, but they're quite different in nature. These lc-net endpoints need to be provisioned to be accessed.

By provisioning an lc-net endpoint, you create a set of VPN credentials that can be used by a single device. One set of credentials should be used by only a single device, they should not be shared among devices.

Once connected, these devices will be able to connect to the internet by default. Connectivity and additional features that can be enabled by lc-net are defined using "policies".

Clients connected can access the internet, but they can also access each other based on the policies you define. This makes lc-net great to secure internal network services for access from specific devices, on premises, on the road, or from home.

The underlying technology used for VPN is called [WireGuard](https://www.wireguard.com/). WireGuard is a next-generation VPN technology that is promoted for its simplicity, speed, and security.

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

The `name` is the name that will be associated with the lc-net device. We recommend using a user identifier like an email address. If you use an email address, you can specify the `--email-user` flag and the QR code + configuration file will be emailed directly to the `name` (email address).

The `--name-file` option allows you to specify a file containing all the names to provision.

The `--output` can be used to send the configuration files directly to a directory.

## Policies

Policies govern the access as well as the configuration of various other tools used by lc-net. Generally policies will apply either to all lc-net endpoints or lc-net endpoints with a given tag applied to them.

Operations on policies are generic and the specific configuration is dependant on the policy type itself.

Policies can be set using the CLI like this:

```
$ limacharlie net policy set --help
usage: limacharlie net policy set [-h] [--policy-file POLICYFILE]
                                  [--policy POLICY]
                                  name type

positional arguments:
  name                  policy name
  type                  policy type

optional arguments:
  -h, --help            show this help message and exit
  --policy-file POLICYFILE
                        path to file with policy content in JSON or YAML
                        format
  --policy POLICY       literal policy content in JSON or YAML format
```

### Firewall

Firewall policies define what *outbound* access is allowed or disallowed. Since all clients in lc-net are under a NAT, the *inbound* access is defined through `service` policies (details further below).

By default when you create a new organization and enable lc-net, a `firewall` policy will be created for you, as specified below.

This default policy gives access by all the clients to the internet without any limitation. This policy is required by default to provide connectivity because lc-net denies all outbound connections by default (safe by default). This means that if you remove this policy, all outbound access will be disabled.

Firewall policies can either specify:
- `is_allow: true` indicating this policy defines a destination that should be allowed
- `is_allow: false` indicating this policy defines a destination that should be denied

On a connection, all `firewall` policies will be applied. For the connection to be allowed, at least one policy must positively allow the traffic. If, however even a single policy defines the destination is *not* allowed, then the connection will be denied.

Sample policy:
```
"default-allow-outbound": {
    "type": "firewall",
    "policy": {
        "tag": "",
        "is_allow": true,
        "protocol": 0,
        "dest_cidr": "0.0.0.0/0",
        "dest_port": ""
    }
}
```

### Service

Service policies define a service available through the network on a specific host, and which other endpoints have access to it.

The `server_sid` specifies the Sensor ID of the lc-net endpoint running the service. The `service_port` defines a specific port (or `0` for any) where the service is running.

The `tag_clients` specifies a tag that defines which lc-net endpoints have access to this service.

The `protocol` defines the [network protocol](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml) ID that the service is allowed on. TCP is `6` and UDP is `17`.

The following example describes that all lc-net endpoints with the `finance` tag should be allowed to connect to the service running on TCP port 8000 for the Sensor ID `9ccd5a2c-e83c-4ffb-8f52-9f48626a6fc6`.

Once in place, accessing this service can be done using the server's Internal IP that is available through the detailed information view of a given sensor. In the case of lc-net endpoints, this Internal IP is always in the `10.x.x.x` range and is static, meaning a sensor is given an Internal IP that it will keep for its whole lifetime, making it easier to bookmark services or even create your own DNS entries for services.

Sample policy:
```
"test-http": {
    "type": "service",
    "policy": {
        "server_port": 8000,
        "server_sid": "9ccd5a2c-e83c-4ffb-8f52-9f48626a6fc6",
        "tag_clients": "finance",
        "protocol": 6
    }
}
```

### Capture

A capture policy defines packet capture that should be done in the cloud and fed back into LimaCharlie's [Artifact system](external_logs.md) where [Detection & Response](dr.md) rules can be created or where [Zeek](zeek.md) can be applied to the packet captures.

Various filters are available. The `ingest_key` is an [Ingestion Key](external_logs.md#using-the-rest-api) created by you in the REST API section.

The following policy demonstrates a full packet capture from a sensor, to be retained in LimaCharlie for 7 days.

Sample policy:
```
"pcap-all": {
    "type": "capture",
    "policy": {
        "days_retention": 7,
        "tag": "vpn",
        "protocol": 0,
        "local_port": 0,
        "remote_port": 0,
        "ingest_key": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
}
```
