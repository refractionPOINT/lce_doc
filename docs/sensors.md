# Sensors

Sensors are offered as a scalable, serverless solution to connect endpoints of an organization to the cloud. 

Once installed, they send telemetry and artifacts from the host to the organization they're registered to in the cloud. The concept of 'sensor' is grounded in LimaCharlie's open source EDR roots but has expanded to cover many sources of security data.

## Quota

All sensors register with the cloud, and many of them may go online / offline over the course of a regular day. For billing purposes, organizations must specify a sensor quota which represents the number of **concurrent online sensors** allowed to be connected to the cloud. 

If the quota is maxed out when a sensor attempts to come online, the sensor will be dismissed and a [`sensor_over_quota`](events.md#sensor_over_quota) event will be emitted.

## Events

All sensors observe host & network activity, packaging telemetry and sending it to the cloud. The types of observable events are dependent on the sensor's type. 

> For a complete list of event types, see [Reference: Event Types](events.md).

## Commands

Commands offer a safe way to interact with a host either for investigation, management, or threat mitigation purposes. 

Sensors can be issued commands from the cloud with several options, depending on the context:

* Manually using the Console of a sensor in the web application
* Manually using the [CLI](https://github.com/refractionPOINT/python-limacharlie)
* Programatically in the response action of a [Detection & Response rule](dr.md)
* Programatically using the [REST API](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI0OQ-task-sensor)

> For a complete list of commands, see [Reference: Commands](sensor_commands.md). Alternatively, view one of the sensor types below to see supported commands.

## Sensor Types

* [Windows](sensors/windows.md)
* [Mac](sensors/mac.md)
* [Linux](sensors/linux.md)
* [Chrome](sensors/chrome.md)
* [Edge](sensors/edge.md)
* [Net](sensors/net.md)

> Need support for a platform you don't see here? Get in touch via [Slack](https://slack.limacharlie.io) or [Email](mailto:answers@limacharlie.io).

## Going Deeper

With familiarity of the core mechanics for sensors, here are some options for further learning:

* [Events](events.md)
* [Commands](sensor_commands.md)
* [Detection & Response](dr.md)
