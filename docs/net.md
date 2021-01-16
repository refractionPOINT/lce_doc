# Net

LimaCharlie Net (lc-net) allows you to secure and monitor network access to your endpoints by providing advanced instrumented VPN access.

lc-net endpoints appear like other endpoints in your LimaCharlie deployment, but they're quite different in nature. These lc-net endpoints need to be provisioned to be accessed.

By provisioning an lc-net endpoint, you create a set of VPN credentials that can be used by a single device. One set of credentials should be used by only a single device, they should not be shared among devices.

Once connected, these devices will be able to connect to the internet by default. Connectivity and additional features that can be enabled by lc-net are defined using "policies".

Clients connected can access the internet, but they can also access each other based on the policies you define. This makes lc-net great to secure internal network services for access from specific devices, on premises, on the road, or from home.

The underlying technology used for VPN is called [WireGuard](https://www.wireguard.com/). WireGuard is a next-generation VPN technology that is promoted for its simplicity, speed, and security.

Clients are available for [Windows, Android, macOS, Linux, iOS and ChromeOS](https://www.wireguard.com/install/). Client configuration is done either through a QR code or a simple configuration file.

## Provisioning

### lc-net-install Service
This LimaCharlie Service called `lc-net-install` currently only supports Windows. It allows you to easily provision
and upgrade an lc-agent to lc-net.

Since it is a LimaCharlie Service it means you can either directly interact with the service or you can issue
service requests via the API and even D&R rules.

To use the service, you will need:

1. The Net version of the Installation Key you want your new lc-net sensors to use: go to the Installation Key section, if you don't have a key create one, and then click the copy-to-clipboard button for the Net key.
2. The Sensor ID (sid) of the sensor you wish to upgrade. If you are using the Service interactively through the web
interface, you may use the Hostname of the sensor and the web interface will auto-complete the Sensor ID.

These steps assume you are using the web interface, but the same basic steps and parameters apply to other methods.

1. Go in the main page of the Organization where you want to upgrade sensors to lc-net.
1. From the left menu, go to the Add-ons section, Services tab, `lc-net-install` service and set to "on".
1. From the left menu, go to the Service Request section.
1. Select the `lc-net-install` service from the "Service" drop down.
1. In the "iid" section, enter the Net Installation Key (obtained earlier).
1. In the "sid" section, select the Sensor ID by hostname or just enter the Sensor ID itself.
1. Click "Request". The service will create a new Job that will be visible from the Organization's main page where you can track the progress of the upgrade. The whole process should take less than a minute.

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
usage: limacharlie net policy set [-h] [--expires-on EXPIRESON]
                                  [--policy-file POLICYFILE] [--policy POLICY]
                                  name type

positional arguments:
  name                  policy name
  type                  policy type

optional arguments:
  -h, --help            show this help message and exit
  --expires-on EXPIRESON
                        optional second epoch when the policy should expire
  --policy-file POLICYFILE
                        path to file with policy content in JSON or YAML
                        format
  --policy POLICY       literal policy content in JSON or YAML format
```

Policies often contain some generic components:

* `bpf_filter`: this is a [tcpdump-like BPF filter syntax](https://biot.com/capstats/bpf.html) describing matching packets. An empty `bpf_filter` will match all traffic.
* `times`: this is a list of Time Descriptors that describe when this policy is valid and applied. If any of the Time Descriptor is valid, the policy will be applied. More details in the Time Descriptor section below.

### Time Descriptor

A Time Descriptor is a block of configuration that describes a period of time. This can be done in a few different ways. These different ways can be combined together.

#### Epoch Times
Specify second epoch timestamps by specifying `ts_start` and `ts_end`.

#### Time of Day
Using a time of day by specifying `time_of_day_start` and `time_of_day_end`. Each of these parameters is an integer representing the 24h time and minute. For example for 16h30m specify `1630`.

#### Day of Week
Using a specific day of the week by specifying `day_of_week` where the value is the integer representing the day of the week starting with Sunday equal to `1`. So for example, Tuesday is `3`.

#### Day of Month
Using a specific day of the week by specifying `day_of_month` where the value is the integer representing the day of the month, from `1` to `31`.

#### Month of year
Using a specific month of the year by specifying `month_of_year` where the value is the integer representing the month, where January is `1` and December is `12`.

#### Example
Let's say you want a policy to be valid from 8 AM to 6 PM, Mondays in the Pacific Time Zone:

```
{
  "time_of_day_start": 0800,
  "time_of_day_end": 1800,
  "tz": "America/Los_Angeles",
  "day_of_week": 2
}
```

### Troubleshooting

It is sometimes useful to see the list of policies that currently apply to a given sensor.
To do this you may use one of the following:

* REST endpoint: `/net/policy/applicable/SID`
* Python CLI: `limacharlie net client policies --help`
* Python SDK: function `getApplicablePolicies(sid)` of the class `limacharlie.Net`

### Policy Types

#### Firewall

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
        "bpf_filter": "",
    }
}
```

#### Service

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

#### Capture

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
        "bpf_filter": ""
        "ingest_key": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
}
```

#### DNS

A DNS policy defines custom DNS entries that are available to some of your lc-net endpoints. This can be used
either for traditional DNS purposes (providing simplified names to access resources), but it can also be used
for security purposes to [sinkhole](https://en.wikipedia.org/wiki/DNS_sinkhole) malicious domains.

These domains are private to your lc-net.

Sample sinkhole for `evil.com` and all its subdomains on all lc-net devices:
```
{
  "domain": "evil.com",
  "tag": "",
  "to_a": [
    "127.0.0.1"
  ],
  "with_subdomains": true
}
```

Sample internal service only for finance devices:
```
{
  "domain": "testserver.srv",
  "tag": "finance",
  "to_a": [
    "10.130.177.248"
  ],
  "with_subdomains": false
}
```

Sample internal cname:
```
{
  "domain": "testserver.srv",
  "tag": "",
  "to_cname": [
    "www.google.com"
  ],
  "with_subdomains": false
}
```

### Examples

#### Prevent Use of a Service
Let's say we want to prevent users on mobile devices from accessing Dropbox. Assuming mobile users are tagged as `mobile` as it
can be done either manually, through a D&R rule or through the tags of an Installation Key.

```
{
  "domain": "dropbox.com",
  "tag": "mobile",
  "to_a": [
    "127.0.0.1"
  ],
  "with_subdomains": true
}
```

#### Prevent SSH
Let's say we want to prevent users working in the Finance Department from using SSH. Assuming Finance users are tagged as `finance` as it
can be done either manually, through a D&R rule or through the tags of an Installation Key.

```
{
  "tag": "finance",
  "is_allow": false,
  "bpf_filter": "tcp port 22"
}
```
