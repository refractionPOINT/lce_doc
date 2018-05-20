# LimaCharlie Cloud

<img src="https://lcio.nyc3.digitaloceanspaces.com/lc.png" width="150">

By [Refraction Point](https://www.refractionpoint.com)

[TOC]

***Glossary [here](glossary.md)***

## Core Concepts
### Sensors
The LC sensor is a cross platform endpoint sensor developed in C.

It provides all the basic types of events needed
for Flight Data Recorder (FDR) type functionality like Processes, Network Connections, Domain Name requests etc.
It also supports some more advanced features like intelligent local caching of events for in depth Incident Response (IR)
as well as some forensic features like dumping memory.

Sensors can be described through [AgentIDs](agentid.md)

### Installer Key
Installer Keys are keys used to install a sensor. By specifying a key at install time the sensor knows where to connect
as well as the cryptographic keys specific to your installation. Installer Keys can also associate specific Tags the first
time a sensor is installed.

### Tags
Sensors can have Tags associated with them. Tags are applied either based on an Installer Key, or
dynamically via Detection & Response Rules.

### Detection & Response Rules
The Detection & Response Rules are an automation engine. The Detection component is a rule that either matches an event
or not. If the Detection component matches, the Response component of the rule is actioned. This can be used to automatically
investigate, mitigate or apply Tags.

### Outputs
Since LimaCharlie Enterprise doesn't store data itself, it needs to relay the data somewhere for longer term storage
and analysis. Where that data is sent depends on which Outputs are activated. You can have as many Output modules
active, so you can send it to two different syslog destinations using the Syslog Output module and then send it two
some cold storage over an Scp Output module.

Output is also split between two categories: "event", "detect" and "audit". Event will be a stream containing the all raw data from
all the sensors, so it tends to be a large amount of data. Detect is a stream of detections generated through the `report`
function of the Detection & Response rules. This means you can send your bulk "event" data to a cheap cold storage and
send all the important "detect" data to a Splunk instance or a Slack channel (using the Slack Output). The "audit" stream
receives all auditing events produced by LCE and is useful for compliance.

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