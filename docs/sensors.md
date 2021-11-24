# Sensors

Sensors are offered as a scalable, serverless solution for securely connecting endpoints of an organization to the cloud. 

Once installed, they send telemetry and artifacts from the host to the organization they're registered to in the cloud. The sensor is grounded in LimaCharlie's open source EDR roots, but is flexible in bringing security data in from different sources.

## Quota

All sensors register with the cloud, and many of them may go online / offline over the course of a regular day. For billing purposes, organizations must specify a sensor quota which represents the number of **concurrent online sensors** allowed to be connected to the cloud. 

If the quota is maxed out when a sensor attempts to come online, the sensor will be dismissed and a [`sensor_over_quota`](events.md#sensor_over_quota) event will be emitted.

## Events

All sensors observe host & network activity, packaging telemetry and sending it to the cloud. The types of observable events are dependent on the sensor's type. 

> For an introduction to events and their structure, see the article on [Events](events-overview.md).

## Commands

Commands offer a safe way to interact with a host either for investigation, management, or threat mitigation purposes. 

### Sending Commands

Sensors can be issued commands from the cloud with several options, depending on the context:

* Manually using the Console of a sensor in the web application
* Manually using the [CLI](https://github.com/refractionPOINT/python-limacharlie)
* Programatically in the response action of a [Detection & Response rule](dr.md)
* Programatically using the [REST API](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI0OQ-task-sensor)

Regardless of method, sent commands are acknowledged immediately with an empty response, followed by a `CLOUD_NOTIFICATION` event sent from the sensor. The actual responses are emitted as sensor events suffixed with `_REP`, depending on the command. 

This non-blocking approach makes responses accessible anywhere that telemetry is flowing.

### Investigation IDs

To assist in finding the responses more easily, you may specify an `investigation_id` (an arbitrary string) with a command. The response will then include that value under `routing/investigation_id`. Under the hood, this is exactly how the Console view in the web application works.

If an `investigation_id` is prefixed with `__` (double underscore) it will omit the resulting events from being forwarded to Outputs. This is primarily to allow Services to interact with sensors without spamming. 


### Command Structure

Commands follow typical CLI conventions using a mix of positional arguments and named optional arguments. 

Here's [`dir_list`](sensor_commands.md#dir_list) as an example:

```
dir_list [-h] [-d DEPTH] rootDir fileExp

positional arguments:
rootDir the root directory where to begin the listing from
fileExp a file name expression supporting basic wildcards like
* and ?

optional arguments:
-h, --help show this help message and exit
-d DEPTH, --depth DEPTH
optional maximum depth of the listing, defaults to a
single level
```

The Console in the web application will provide autocompletion hints of possible commands for a sensor and their parameters, but commands and their usage details may be programatically retrieved via the [`/tasks`](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI1OQ-get-possible-tasks) and [`/task`](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI3OA-autocomplete-task) REST API endpoints, respectively.  

> For a complete list of commands, see [Reference: Commands](sensor_commands.md). Alternatively, view one of the sensor types below to see supported commands.

## Sensor Types

* [Windows](sensors/windows.md)
* [Mac](sensors/mac.md)
* [Linux](sensors/linux.md)
* [Chrome](sensors/chrome.md)
* [Edge](sensors/edge.md)
* [Net](sensors/net.md)

> Need support for a platform you don't see here? Get in touch via [Slack](https://slack.limacharlie.io) or [Email](mailto:answers@limacharlie.io).

## Sensor Versions

Windows, Mac, and Linux (EDR-class) sensors' versions are cloud-managed per-organization. They will not upgrade unless you choose to do so. 

There are always two versions available to roll out &mdash; `Stable` or `Latest` &mdash; which can be deployed via the web application or via the [`/modules` REST API](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI2OA-update-sensors). 

## Going Deeper

With familiarity of the core mechanics for sensors, here are some options for further learning:

* [Events](events.md)
* [Commands](sensor_commands.md)
* [Detection & Response](dr.md)
