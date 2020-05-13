# ID Schemes

[TOC]

## Agent IDs

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

* `0x10000000`: Windows
* `0x20000000`: Linux
* `0x30000000`: MacOS
* `0x40000000`: iOS (unused)
* `0x50000000`: Android (unused)
* `0x60000000`: ChromeOS

## Architecture
The architecture is an 8 bit integer that identifies the exact architecture the sensor runs on. The important values are:

* `1`: 32 bit
* `2`: 64 bit
* `3`: ARM
* `4`: ARM64
* `5`: Alpine 64
* `6`: Chrome