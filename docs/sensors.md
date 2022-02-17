# Sensors

Sensors are offered as a scalable, serverless solution for securely connecting endpoints of an organization to the cloud. 

Once installed, they send telemetry and artifacts from the host to the organization they're registered to in the cloud. The sensor is grounded in LimaCharlie's open source EDR roots, but is flexible in bringing security data in from different sources.

## Sensor Types

* [Windows](sensors/windows.md)
* [Mac](sensors/mac.md)
* [Linux](sensors/linux.md)
* [Chrome](sensors/chrome.md)
* [Edge](sensors/edge.md)
* [Net](sensors/net.md)
* [External Telemetry (like 1Password, CarbonBlack, Office 365 etc)](../lc_adapter.md)

> Need support for a platform you don't see here? Get in touch via [Slack](https://slack.limacharlie.io) or [email](mailto:answers@limacharlie.io).

## Quota

All sensors register with the cloud, and many of them may go online / offline over the course of a regular day. For billing purposes, organizations must specify a sensor quota which represents the number of **concurrent online sensors** allowed to be connected to the cloud. 

If the quota is maxed out when a sensor attempts to come online, the sensor will be dismissed and a [`sensor_over_quota`](events.md#sensor_over_quota) event will be emitted in the [`deployments`](events-overview.md#streams) stream.

## Events

All sensors observe host & network activity, packaging telemetry and sending it to the cloud. The types of observable events are dependent on the sensor's type. 

> For an introduction to events and their structure, check out the [Events Overview](events-overview.md).

## Commands

Windows, Mac, Linux, Chrome, and Edge sensors all offer commands as a safe way of interacting with a host for investigation, management, or threat mitigation purposes. 

> For an introduction to commands and their usage, check out the [Commands Overview](sensor-commands-overview.md).

> For a complete list of commands, see [Reference: Commands](sensor_commands.md). Alternatively, check out any the sensor types individually to see their supported commands.

## Installation Keys

An Installation Key binds a sensor to the Organization that generated the key, optionally tagging them as well to differentiate groups of sensors from one another.

It has the following properties:

* OID: The Organization Id that this key should enroll into.
* IID: Installer ID that is generated and associated with every Installation Key.
* Tags: A list of Tags automatically applied to sensors enrolling with the key.
* Desc: The description used to help you differentiate uses of various keys.

### Recommended Usage

We recommend using multiple installation keys per organization to differentiate endpoints in your deployment. 

For example, you may create a key with Tag "server" that you will use to install on your servers, a key with "vip" for executives in your organization, or a key with "sales" for the sales department, etc. This way you can use the tags on various sensors to figure out different detection and response rules for different types of hosts on your infrastructure.

## Sensor Versions

Windows, Mac, and Linux (EDR-class) sensors' versions are fixed and can be managed per-organization. They will not upgrade unless you choose to do so. 

There are always two versions available to roll out &mdash; `Stable` or `Latest` &mdash; which can be deployed via the web application or via the [`/modules` REST API](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI2OA-update-sensors). 

## Going Deeper

With familiarity of the core mechanics for sensors, here are some options for further learning:

* [Events](events.md)
* [Commands](sensor_commands.md)
* [Detection & Response](dr.md)
