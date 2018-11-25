# LimaCharlie.io

<img src="https://lcio.nyc3.digitaloceanspaces.com/logo.png" width="150">

***[Get Started Here](https://limacharlie.io)***

[TOC]

## Quick Start
To skip all of the details and get setup with endpoint detection and response capability you can follow our [quick start instructions](lcc_quick_start.md).

## Core Concepts
### Sensors
The LimaCharlie sensor is a cross platform endpoint sensor (agent). It is a low-level, light-weight sensor that executes detection and response functionality in real-time.

The sensor provides a wide range of advanced capability.
* Flight Data Recorder (FDR) type functionality like Processes, Network Connections, Domain Name requests etc.
* Host isolation, automated response rules, intelligent local caching of events for in depth Incident Response (IR)
as well as some forensic features like dumping memory.

Sensors are designed to limit the potential for abuse resulting from unauthorized access to the LimaCharlie platform.
This is achieved by limited open-ended commands as well as commands that could enable an attacker to
covertly upload malicious software to your hosts. This means the LimaCharlie sensor is extremely powerful
but also keeps its "read-only" qualities on your infrastructure. Of course, all access and interactions with the hosts
are also logged for audit both within the cloud and tamper-proof forwarding to your own infrastructure.

Full commands list is in the [Sensor Commands section](sensor_commands.md).

### Installer Key
Installer Keys are used to install a sensor. By specifying a key during installation the sensor can cryptographically be tied to your account.
Get more detaisl in the [Installation Keys section](manage_keys.md).

### Tags
Sensors can have Tags associated with them. Tags are added during creation or dynamically through the UI, API or Detection & Response Rules.
Get more information in the [Tagging section](tagging.md).

### Detection & Response Rules
The Detection & Response Rules act as an automation engine. The Detection component is a rule that either matches an event
or not. If the Detection component matches, the Response component of the rule is actioned. This can be used to automatically
investigate, mitigate or apply Tags.

Detailed explanation in the [Detection & Response section](dr.md).

### Insight
Insight is our built-in data retention and searching. It included within our 2 sensor free tier as well.

When you enable Insight, we configure everything you so that you get access to one year of your data for visualization and searching.

You don't *have to* use the built-in data retention, you can forward data to your infrastructure
directly if you'd like. In general though, it is much simpler and a better experience to use Insight. If you prefer not to use Insight
go through the next section (Outputs).

### Outputs
If you are using Insight (data retention), you can skip this section.

LimaCharlie can relay the data somewhere for longer term storage and analysis. Where that data is sent depends on which Outputs
are activated. You can have as many Output modules active, so you can send it to two different syslog destinations using
the Syslog Output module and then send it two some cold storage over an Scp Output module.

Output is also split between two categories: "event", "detect" and "audit". Event will be a stream containing the all raw data from
all the sensors, so it tends to be a large amount of data. Detect is a stream of detections generated through the `report`
function of the Detection & Response rules. This means you can send your bulk "event" data to a cheap cold storage and
send all the important "detect" data to a Splunk instance or a Slack channel (using the Slack Output). The "audit" stream
receives all auditing events produced by LCE and is useful for compliance.

Exact configuration possibilities in the [Output section](outputs.md).

### API Keys
The API keys are represented as UUIDs. They are linked to your specific organization and enable you to programatically acquire
authorization tokens that can be used on our REST API. See the [API Key section](api_keys.md) for more details.

## Operations

### Quick Start
* [LimaCharlie Cloud Quick Start](lcc_quick_start.md)

### User Operations
* [Manage Installation Keys](manage_keys.md)
* [Manage Tags](tagging.md)
* [Manage Detection & Response Rules](dr.md)
* [Sensor Commands](sensor_commands.md)
* [Output Configuration](outputs.md)
* [Deploying Sensors](deploy_sensor.md)
* [Add-ons](user_addons.md)

### Reference
* [Events](events.md)

### FAQ
* [FAQ](faq.md)
