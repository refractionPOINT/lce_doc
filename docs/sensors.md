# Sensors

Sensors are offered as a scalable solution for connecting the endpoints of an organization. Once installed, they send telemetry and artifacts from the host to the organization they're registered to in the cloud. The concept of 'sensor' is grounded in LimaCharlie's open source EDR roots but has expanded to cover many sources of security data.

## Quota

All sensors register with the cloud, and many of them may go online / offline over the course of a regular day. For billing purposes, organizations must specify a sensor quota which represents the number of **concurrent online sensors** allowed to be connected to the cloud. 

If the quota is maxed out when a sensor attempts to come online, the sensor will be dismissed and a [`sensor_over_quota`](events.md#sensor_over_quota) event will be emitted.

## Events

All sensors observe host & network activity, packaging telemetry and sending it to the cloud. The types of observable events are dependent on the sensor's type. 

> For an overview of how events in LimaCharlie are structured, see [Events](events-overview.md). For a complete reference list of possible event types, see [Reference: Event Types](events.md).

## Commands

Many sensors accept commands from the cloud either manually, [via D&R rules](dr.md), or [via REST API](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI0OQ-task-sensor). 

Commands offer a safe way to interact with a host either for investigation, management, or threat mitigation purposes. To learn about available commands, check out [the reference list](sensor_commands.md).

## Sensor Types

### Windows, Mac, Linux (EDR)

The bread and butter of LimaCharlie. These sensors are low-level and light-weight, interfacing with the operating system kernel to acquire deep visibility into the host's activity while taking measures to preserve the host's performance. 

#### Events

* Process activity
* File system
* Registry
* Network connections
* Domain name requests
* Windows Event Logs (on Windows only, of course)

#### Commands

Most commands are supported by EDR sensors. To give an idea of what's possible:

* Network isolation
* Start / stop / kill processes
* End entire process trees

#### Additional Capabilities

* [**Artifact Collection**](external_logs.md): Given configured paths to collect from, EDR sensors can batch upload logs / artifacts directly from the host.
* [**Payloads**](payloads.md): For more complex needs not supported by [Events](events.md), [Artifacts](external_logs.md), or [Commands](sensor_commands.md), it's possible to execute payloads on hosts via sensors.

### Chrome, Edge (Browser Extensions)

The browser-based sensors are particularly useful for gaining affordable network visibility in organizations making heavy use of ChromeOS.

#### Supported Events

* [`CONNECTED`](events.md#CONNECTED)
* [`RECEIPT`](events.md#RECEIPT)
* [`HTTP_REQUEST`](events.md#HTTP_REQUEST)
* [`DNS_REQUEST`](events.md#DNS_REQUEST)

#### Supported Commands

* [`os_packages`](sensor_commands.md#os_packages)
* [`dns_resolve`](sensor_commands.md#dns_resolve)
* [`history_dump`](sensor_commands.md#history_dump)
* [`rejoin_network`](sensor_commands.md#rejoin_network)
* [`segregate_network`](sensor_commands.md#segregate_network)


### Network: Net

Connect to a granular, software-based network perimeter.

### Log Adapters

Ingest logs directly from sources like S3, CloudTrail, GCS, 1Password, and more to come.

## Access

Sensors are sensitive in nature, so they're designed to limit potential harm from unauthorized access to the LimaCharlie platform.

Sensor commands are limited to ensure an attacker can't covertly upload malicious software, and all access and interactions with hosts will produce audit logs viewable either in LimaCharlie or by forwarding them to the destination of your choosing as an [Output](outputs.md).

## Going Deeper

This has been an overview of sensors and their mechanics. 