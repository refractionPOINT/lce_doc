# LimaCharlie Enterprise

<img src="https://lcio.nyc3.digitaloceanspaces.com/lc.png" width="150">

By [Refraction Point](https://www.refractionpoint.com)

* TOC
{:toc}

## Overview
LimaCharlie Enterprise (LCE) is a specialized backend for the Open Source LimaCharlie (LC) endpoint 
sensor focusing on enterprise features, stability and performance.

***Glossary [here](glossary.md)***

## Highlights
### Fully Hosted or On Premise
LCE is offered as a fully hosted platform or in some cases on premise. The hosted solution means you never have
to worry about scaling or maintaining the platform. It also means you get access to your own LCE deployment giving
you access to the full power of LCE like deploying your own D&R rules.

Whatever configuration you deploy on, LCE will give you complete management over a REST interface or a basic web interface.
This means you can trivially integrate with other solutions, any system can send commands to the endpoint sensors.

### Detect & Response Rules
Create extremely powerful rules on the fly to automate detection, mitigation or general endpoint management. These rules
make it easy to leverage complex powerful external solutions like `virustotal( hash )`, `malwaredomains( domain )` and 
`geolocate( ip )`. For example,
want to stop Wanacry in its tracks?

#### Detect
```python
event.Process( pathEndsWith = '@wanadecryptor@.exe' )
```
#### Respond
```python
sensor.task( [ 'deny_tree', event.atom ] ) and sensor.task( 'segregate_network' ) and report( name = 'wanacry' )
```

### Output Data
Output the data where you want it and for however long you want it. Maintain ownership of your data, decide the retention.
LCE can output data in realtime through tons of different methods like syslog, scp, file, Slack etc. Decide where the bulk
data goes and where detections go to allow for faster response in your SOC.

## Core Concepts
### Sensors
The LC sensor is a cross platform endpoint sensor developed in C.

It provides all the basic types of events needed
for Flight Data Recorder (FDR) type functionality like Processes, Network Connections, Domain Name requests etc.
It also supports some more advanced features like intelligent local caching of events for in depth Incident Response (IR)
as well as some forensic features like dumping memory.

Sensors can be described through [AgentIDs](agentid.md)

### Backend
The LCE backend runs on a Linux based appliance running Cassandra for storage and Beach for compute. These appliances
are designed to scale a deployment by supporting clustering of their storage and compute.

### Control Plane
The Control Plane is a REST interface allowing you to manage multiple LC Backends using a single interface. The Control Plane
is documented using Swagger and uses JWT for authentication. By default the Control Plane is accessible at
* Swagger-based REST API documentation: `https://<your_node_running_backend>:8888/static/swagger`
* Basic Web UI on top of REST: `https://<your_node_running_backend>:8888/static/ui`
* REST API root: `https://<your_node_running_backend>:8888/v1/`

### Modules
The Modules are the binary payloads loaded by the LC sensor that provides the core of its capabilities. This component
is easily upgradable. For change management reasons it is not automatically updated to the most recent version, but
doing so is a simple REST call to the Control Plane.

### Installer Key
Installer Keys are keys used to install a sensor. By specifying a key at install time the sensor knows where to connect
as well as the cryptographic keys specific to your installation. Installer Keys can also associate specific Tags the first
time a sensor is installed.

### Tags
Sensors can have Tags associated with them. Tags are applied either based on an Installer Key, or
dynamically via Detection & Response Rules.

### Profiles
Sensor can be configured using Profiles. The Profiles define which Collectors (major functionality categories)
are enabled and disabled. Some Collectors can use additional data (like lists of file extensions). The Exfil Collector
also controls exactly which events are sent in realtime to the backend verssus which ones are only cached locally until
requested.

Profiles are applied by specifing a AgentId mask (which includes an Organization Id, Installer Id, Sensor Id, Platform
and Architecture) along with a specific Tag (optional).

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
***If you are a cloud hosted customer, this will get you started.***
* [LimaCharlie Enterprise Quick Start](lce_quick_start.md)
* [LimaCharlie Cloud Quick Start](lcc_quick_start.md)

### User Operations
* [Create Organization](new_org.md)
* [Update Organization Module](update_org.md)
* [Manage Installation Keys](manage_keys.md)
* [Manage Tags](tagging.md)
* [Manage Profiles](profiles.md)
* [Manage Detection & Response Rules](dr.md)
* [Sensor Commands](sensor_commands.md)
* [Output Configuration](outputs.md)
* [Deploying Sensors](deploy_sensor.md)

### Reference
* [Collectors](collectors.md)
* [Events](events.md)

### Appliance Operations
***Unless you are running LCE on premise you don't need to know about this.***
* [New Cluster](new_cluster.md)
* [Appliance Operations](appliance_ops.md)
* [Simple Configuration](simple_conf.md)
* [Connectivity](connectivity.md)