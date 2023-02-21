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
The platform is a 32 bit integer (in its hex format) which identifies the exact platform the sensor runs on. Sensor telemetry will display the `plat` value in decimal format. Although it is structured with a major and minor platform, the important values are:

Hex (decimal): Platform name (API name)
* `0x10000000` (268435456): Windows (`windows`)
* `0x20000000` (536870912): Linux (`linux`)
* `0x30000000` (805306368): MacOS (`macos`)
* `0x40000000` (1073741824): iOS (unused) (`ios`)
* `0x50000000` (1342177280): Android (unused) (`android`)
* `0x60000000` (1610612736): ChromeOS (`chrome`)
* `0x80000000` (2147483648): Text (external telemetry) (`text`)
* `0x90000000` (2415919104): JSON (external telemetry) (`json`)
* `0xA0000000` (2684354560): GCP (external telemetry) (`gcp`)
* `0xB0000000` (2952790016): AWS (external telemetry) (`aws`)
* `0xC0000000` (3221225472): VMWare Carbon Black (external telemetry) (`carbon_black`)
* `0xD0000000` (3489660928): 1Password (external telemetry) (`1password`)
* `0xE0000000` (3758096384): Microsoft/Office 365 (external telemetry) (`office365`)
* `0x01000000` (16777216): CrowdStrike (external telemetry) (`crowdstrike`)
* `0x02000000` (33554432): XML (external telemetry) (`xml`)
* `0x03000000` (50331648): Windows Event Logs (external telemetry) (`wel`)
* `0x04000000` (67108864): Microsoft Defender (external telemetry) (`msdefender`)
* `0x05000000` (83886080): Duo (external telemetry) (`duo`)
* `0x08000000` (134217728): GitHub (external telemetry) (`github`)
* `0x09000000` (150994944): Slack (external telemetry) (`slack`)
* `0x0A000000` (167772160): Common Event Format (CEF) (`cef`)
* `0x0B000000` (184549376): LimaCharlie Events (`lc_event`)

Tip: If you're writing a D&R rule to target a specific platform, consider using the [`is platform` operator](https://doc.limacharlie.io/docs/documentation/4c4fab0fe5866-reference-operators#is-platform) instead of the decimal value for easier readability.

## Architecture
The architecture is an 8 bit integer that identifies the exact architecture the sensor runs on. The important values are:

* `1`: 32 bit (`x86`)
* `2`: 64 bit (`x64`)
* `3`: ARM (`arm`)
* `4`: ARM64 (`arm64`)
* `5`: Alpine 64 (`alpine64`)
* `6`: Chrome (`chromium`)
* `7`: Wireguard (`wireguard`)
* `8`: ARML (`arml`)
* `9`: lc-adapter (`usp_adapter`)

## Device IDs
Given the breadth of platforms supported by LimaCharlie, it is not unusual for one "device" (laptop, server, mobile etc) to be visible from multiple sensors. A basic example of this might be:

* We have a laptop
* The laptop's Operating System is macOS, running a macOS sensor
* The laptop is also running a Windows Virtual Machine, running a Windows sensor

In this example, we're dealing with one piece of hardware, but 3 different sensors.

To help provide a holistic view of activity, LimaCharlie introduces the concept of a Device ID. This ID is mostly visible in the sensor's basic info and in the `routing` component of sensor events under the name `did` (Device ID).

This Device ID is automatically generated and assigned by LimaCharlie using correlation of specific low level events common to all the sensors. This means that if two sensors share a `did: 1234-5678...` ID, it means they are either on the same device or at least share the same visibility (they see the same activity from two angles).
