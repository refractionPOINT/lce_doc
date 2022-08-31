# Net Sensor

LimaCharlie's Net sensor enables both network visibility and granular network access control. It is built on top of the WireGuard VPN tunnel client, which effectively routes all network activity through your organization's Net Policies.

## Installation Instructions

Sensor installation instructions can be found [here.](https://doc.limacharlie.io/docs/documentation/ZG9jOjU4NjkzNDA-lima-charlie-net-secure-access-service-edge-sase) 

## Supported Events

* [`NETWORK_CONNECTIONS`](../events.md#network_connections)
* [`DNS_REQUEST`](../events.md#dns_request)

## Supported Commands

The Net sensor has no support for commands.

## Net Policies

Net policies shape the network through a software-based perimeter, configurable in the cloud via the web application. There are 4 different policy types to achieve different goals. 

### Firewall

Defines what outbound access is allowed or disallowed.

### Service

Defines a specific host's availability through the network to other hosts.

### Capture

Defines packet captures to be collected as [Artifacts](../external_logs.md).

### DNS

Defines custom DNS entries available to Net sensors.
