# ID Schemes

## Agent IDs

An AgentID is a 5-tuple that completely describes a sensor, while a SensorID is the smallest single unique identifier
that can identify a sensor.

The AgentID's components look like this: `OID.IID.SID.PLATFORM.ARCHITECTURE`.

For all components, a value of `0` indicates a wildcard that matches any value when comparing AgentIDs as masks.

## OID
The OID (Organization ID) is a UUID which identifies a unique organization.

## IID
The IID (Installer ID) is a UUID that identifies a unique installation key. This allows us to cycle installation keys and
repudiate old keys, in the event the key gets leaked.

## SID
The SID (Sensor ID) is a UUID that identifies a unique sensor.

## Platform
The platform is a 32 bit integer (in its hex format) which identifies the exact platform the sensor runs on. Although it is
structured with a major and minor platform, the important values are:

* `0x10000000`: Windows
* `0x20000000`: Linux
* `0x30000000`: MacOS
* `0x40000000`: iOS (unused)
* `0x50000000`: Android (unused)
* `0x60000000`: ChromeOS
* `0x70000000`: lc-net
* `0x80000000`: Text (external telemetry)
* `0x90000000`: JSON (external telemetry)
* `0xA0000000`: GCP (external telemetry)
* `0xB0000000`: AWS (external telemetry)
* `0xC0000000`: VMWare Carbon Black (external telemetry)
* `0xD0000000`: 1Password (external telemetry)
* `0xE0000000`: Microsoft/Office 365 (external telemetry)
* `0x02000000`: XML (external telemetry)
* `0x03000000`: Windows Event Logs (external telemetry)
* `0x04000000`: Microsoft Defender (external telemetry)

## Architecture
The architecture is an 8 bit integer that identifies the exact architecture the sensor runs on. The important values are:

* `1`: 32 bit
* `2`: 64 bit
* `3`: ARM
* `4`: ARM64
* `5`: Alpine 64
* `6`: Chrome
* `7`: Wireguard
* `8`: ARML
* `9`: lc-adapter

## Device IDs
Given the breadth of platforms supported by LimaCharlie, it is not unusual for one "device" (laptop, server, mobile etc) to be visible from multiple sensors. A basic example of this might be:

* We have a laptop
* The laptop's Operating System is macOS, running a macOS sensor
* The laptop is also running a Windows Virtual Machine, running a Windows sensor
* Finally, the laptop is running an lc-net sensor at the macOS level

In this example, we're dealing with one piece of hardware, but 3 different sensors.

To help provide a holistic view of activity, LimaCharlie introduces the concept of a Device ID. This ID is mostly visible in the sensor's basic info and in the `routing` component of sensor events under the name `did` (Device ID).

This Device ID is automatically generated and assigned by LimaCharlie using correlation of specific low level events common to all the sensors. This means that if two sensors share a `did: 1234-5678...` ID, it means they are either on the same device or at least share the same visibility (they see the same activity from two angles).