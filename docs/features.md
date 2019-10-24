# Feature Overview

[TOC]


## Security Features

### Sensor Platforms

The LimaCharlie sensors support the following platforms:

* Windows XP 32 bit and up.
* MacOS 10.7 and up.
* Linux all distributions.
* Alpine Linux 64 bit
* Chrome and ChromeOS

### Retention

* Full telemetry and alerts are fully retained for a full year.
* Indicators of Compromise are also indexed and searchable.

### Events Control

* Control which event types are sent to the cloud and when (exfil).
* Set watch-lists for events with certain characteristics to exfil.
* Change the exfil events with timeouts dynamically.
* Retroactively retrieve full event details automatically and on demand.

### Sensor Commands

Send [commands](sensor_commands.md) to sensors in real-time on demand, automatically or through APIs.

### Historic Visualization

* Visualize detailed activity part of the retention for specific hosts at any point in time.
* Filter events by type or content.

### Live Interaction

* Perform live actions against sensors.
* Survey current activity on a host.
* Investigate incidents or anomalies in real-time (100ms round trips) interactively, automatically or using APIs.

### IoC Search

* Search for Indicators of Compromise (IoC) on the full year of retained data in seconds.
* Search interactively or through APIs.
* Jump to detailed Historical view from IoC search.

### Data Forwarding

* Setup complex forwarding rules for different types of telemetry and alerts.
* Supports most common technologies like Syslog, SFTP, AWS S3, Google Storage, SMTP etc.
* Forwarding is done in real-time or near real-time depending on forwarding methodology.

### Detection & Response Rules

* Cloud based rules defining a behavior to detect and actions to take when detected.
* Operate in real-time at wire-speed.
* Operated like AWS Lambda or Cloud Functions.

#### IP Geolocation

* Get IP geolocation information and use within a rule.

#### Virus Total

* Query [VirusTotal](https://virustotal.com) with hashes and match if a certain number of Anti-Virus engines report maliciousness.

#### String Distance

* Compare telemetry using [Damerau-Levenshtein distance](https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance) to allow you to detect phishing attempts or files masquerading as others.

#### False Positive Rules

* Create custom rules to identity and suppress alerts.

#### Namespaces

* Use namespaces to segment Detection & Response rules.
* Allows Service Providers to manage rules for customers.

### Retroactive Hunting

* Replay historical telemetry against Detection & Response rules.
* Allows you to create a new rule and see if it would have generated an alert in the last year.

#### Continuous Integration & Deployment

* Integrate Detection & Response rules development with devops CI/CD pipelines.
* Determine if a change to a rule would generate a lot of False Positives in production.

### File & Registry Integrity Monitoring

* Monitor specific directories or Registry paths for changes.
* Generate events on changes that can be used as part of Detection & Response rules.

### Yara Scanning

* Scan using sets of Yara signatures.
* Scan on demand specific processes, files or memory.
* Scan in continuous mode, throttled to limit impact on performance. Fire and forget.

### Custom Payload and Shell Execution

* Upload and run arbitrary executables on hosts.
* Execute arbitrary shell commands on hosts.

### External Logs

* Upload "external log" (non-LC data) to the LimaCharlie platform.
* Upload from a REST API, Command Line Interface or directly from a sensor.
* Visualize logs in text or JSON formats.
* Fetch original log files through API.
* Retained for a full year.

#### Formats

* Multiple formats are supported like:
    * Windows Event Logs
    * Syslog (text logs)
    * Packet Capture (PCAP)
    * Prefetch files

#### Normalization

* Binary formats are converted to JSON for easy viewing and parsing.

#### Detection & Response

* Build Detection & Response rules that apply specifically to "external logs".
* Detect behaviors or IoCs from any log type or forensic type files ingested.

#### IoC Searching

* Indicators of Compromise (IoC) from "external logs" are extracted, indexed and searchable.

## Management Features

* Management of deployments at scale for Service Providers.

### CLI, APIs & SDKs

* Manage LimaCharlie using:
    * REST APIs
    * Web Interface
    * Command Line Interface
    * Python SDK
    * NodeJS SDK

### Infrastructure as Code

* Manage multiple organizations/deployments using configuration files at scale.
* Import and Export configuration files to and from organizations.
* Integrates into CI/CD devops pipelines and source control.

### Role Based Access Control

* Control who has access, and what type of access to organizations.
* Control access across multiple organizations and users using Organization Groups.

### Centralized Billing

* Centralized a Billing Point of Contact for all organizations created by members of your domain.

### White Label

* White label the web interface with your logo, colors and domain.