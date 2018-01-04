***[Back to documentation root](README.md)***

# Agent IDs

An AgentID is a 5-tuple that completely describes a sensor, whereas a SensorID is the smallest single unique identifier
that can identify a sensor.

The AgentID's components look like this: `OID.IID.SID.PLATFORM.ARCHITECTURE`.

For all components, a value of `0` indicates a wildcard value that matches any value when comparing AgentIDs as masks.

## OID
The OID (Organization ID) is a UUID that identifies a unique organization.

## IID
The IID (Installer ID) is a UUID that identifies a unique installation key. This allows us to cycle installation keys and
repudiate old keys (in the event the key gets leaked).

## SID
The SID (Sensor ID) is a UUID that identifies a unique sensor.

## Platform
The platform is a 32 bit integer (in its hex format) that identifies the exact platform the sensor runs on. Although it is
structured with a major and minor platform, the important values are:
* `10000000`: Windows
* `20000000`: Linux
* `30000000`: MacOS

## Architecture
The architecture is an 8 bit integer that identifies the exact architecture the sensor runs on. The important values are:
* `1`: 32 bit
* `2`: 64 bit
