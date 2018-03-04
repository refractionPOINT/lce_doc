***[Back to documentation root](README.md)***

# Glossary

| Term | Description
| --- |---
| AgentID | 5-tuple value that completely describes a sensor
| Architecture | An 8 bit integer that identifies the exact architecture the sensor runs on
| Backend | LCE Linux based appliance running Cassandra for storage and Beach for compute
| Beach | Python private compute cloud framework
| Cassandra | Distributed NoSQL database management system designed to handle large amounts of data across many commodity servers
| Collector | Major functionality category
| Control plane | REST interface for managing multiple LC Backends from a single RESTful web services framework
| Detect (output) | Stream of detections generated through the `report` function of the D&R rules
| D&R (rule) | Automation engine to automatically investigate, mitigate or apply tags
| Event (output)| Stream containing the all raw data from all the sensors (it tends to be a large amount of data)
| Exfil | Collector aimed to define which events are sent in realtime to the backend and which ones are cached locally
| FDR | Flight Data Recorder functionality
| IID or InstallerID | Value that identifies a unique installation key
| Installer Key | Value specified at install time to configure a sensor (will include connection path and cryptographic keys)
| IR | Incident response
| LC | Lima Charlie Community edition
| LCE | Lima Charlie Enterprise edition
| Module | Binary payload loaded by the LCE sensor that provides the core of its capabilities
| OID or OrganizationID | A value that identifies a unique organization
| Output| Data relay for longer term storage and analysis
| Platform | A 32 bit integer (in its hex format) that identifies the exact platform the sensor runs on
| Profile | Value that defines which Collectors are enabled and disabled
| Restful | Representational state transfer web services aimed to provide interoperability between systems across the Internet
| Sensor | Open source cross platform endpoint sensor developed in C
| SensorID | The smallest single unique identifier that can identify a sensor
| Swagger | Software framework backed by a large ecosystem of tools aimed to provide RESTful web services
| Tag | A label to be associated to sensors either based on an installer key, or dynamically via D&R rules
| UUID | Unique ID
