# Artifact Collection

[TOC]

The Artifact Collection system allows you to ingest artifact types like:

* Plain text logs (syslog for example)
* Windows Event Logs
* PCAPs
* Windows Prefetch files
* Windows PE (executables) files
* [Zeek](https://zeek.org) (previously Bro)
* Full memory dumps
* Generic JSON
* OLE (MS Word, Excel etc)

Those artifacts can be ingested from hosts running a LimaCharlie sensor, or they
can be pushed to the LimaCharlie platform via a REST interface.

Once ingested, the artifacts are retained and made available to you with a
custom retention period.
Ingested artifacts are also indexed similarly to LimaCharlie events. This means
that you can search all of your artifact for the last year for Indicators like
IP Addresses, Domain Names, User Names, Hashes etc.

This in turn makes it possible for you to be looking at sensor data, identity
an IP of interest, and launch a quick search to see if this IP has been observed
in any artifacts over the past year. If it has, with one click you can visualize the
relevant artifact entries to assist you in your investigation.

We call this "artifact operationalization". It is not mean to be a general viewing
and querying tool like Splunk, but as a tactical tool providing you with critical
answers as you need them during security operations.

Note that Artifact Collection configurations are synchronized with sensors every few minutes.

## Ingestion
### Using LC Sensors
The LimaCharlie sensor can be used to retrieve artifact files directly from hosts.

#### Manually
To instruct the ingestion of an artifact file located on a host where LC is installed,
simply issue the [artifact_get](sensor_commands.md#artifact_get) command. You should receive
two events in response to this command: a general receipt indicating the sensor
received the command, and a response with a status code indicating whether the
ingestion was successful (an error code of `200` (as in HTTP) indicates success).

#### Using the Service

##### Collection
With the Artifact Collection Service enabled, a new section should be open in the web
interface. It will allow you to manage the automatic collection of files from
your fleet without manual input or configuration.

The service manages this through the use of Rules that specify a set of Platforms
(like Windows), Tags (sensor tags), a retention time and file patterns.

Rules define which file path patterns should be monitored for changes and ingested for specific sets of hosts.

Filter tags are tags that must ALL be present on a sensor for it to match (ANDed), while the platform of the sensor much match one of the platforms in the filter (ORed).

Patterns are file path where the file expression at the end of the path can contain patterns line (`*`, `?`, `+`).

These wildcards are NOT supported in the path portion of the pattern.
Windows directory separators (backslash, `\`) must be escaped like `\\`.

Good example: `/var/log/*.1`

Bad example: `/var/*/syslog`

Note that matching files are watched for changes. When a change is detected, the entire file is ingested. This means you usually want to target logs that get rolled over after a certain time.

For example syslog is rolled from `syslog` to `syslog.1` after a day, you want to target `syslog.1` to avoid duplicating records from a file being appended to.

##### Network Capture
The service also offers a rule system to do network capture from the host. This
feature is currently only available on Linux.

To see the network interfaces available for capture, issue the `pcap_ifaces` command to the sensor.

Each capture rule filters a set of sensor per platform and tag. The second part of the rule
is the list of patterns to capture from. Each pattern defines a network interface to use
and a [tcpdump-like](https://www.tcpdump.org/manpages/pcap-filter.7.html) filter expression to select traffic from that interface.

The filter part of the capture pattern will automatically receive an additional "filter out" expression that removes
traffic related to LimaCharlie itself (to avoid a feedback loop of traffic).

For example, you could specify the filter:

```
tcp port 80
```

which would automatically be expanded for you as

```
tcp port 80 and not lc.aaa.limacharlie.io and not ...
```

These rules get synced with agents every 10 minutes. Once a capture on the agent reaches a certain
threshold (about 30MB), the capture will get automatically sent to the LimaCharlie cloud with the
retention specified in the rule. From there you can specify D&R rules to process further the pcap
data automatically, like using the [Zeek](zeek.md) service.

### Using the CLI
To simplify the task on ingesting via the REST API, you can use the LC CLI tool (`pip install limacharlie`).
Using this tool, you can use the `limacharlie artifacts --help` command it installs.
This is the recommended way of ingesting logs from external systems where LC is not installed.

### Using the REST API
When the sensor is tasked to ingest an artifacts file, it itself uses the REST API.

The REST API uses Ingestion Keys, which can be managed through the REST API
section of the LC web interface. Access to manage these Ingestion Keys requires
the `ingestkey.ctrl` permission.

The REST endpoint is located at a per-datacenter URL. You can query the relevant
URL for your organization using [this REST call](https://api.limacharlie.io/static/swagger/#/orgs/get_orgs__oid__url).

The endpoint is authenticated using Basic Authentication with the user name being
the Organization ID (OID) and the password the Ingestion Key, via a POST.

The body of the POST contains the artifact file to ingest. Additional metadata is provided
using the following Header fields:

* `lc-source` is a free form string used as an identifier of the origin of the artifact. When an artifact is ingested from a LC sensor, this value is the Sensor ID (SID) of the sensor.
* `lc-hint` if present, this indicates to the backend how the file should be interpreted. It default to `auto` which results in the backend auto-detecting the formal. Currently supported hints include `wel` (Windows Events Log), `prefetch` (Windows prefetch file), `pcap`, `txt`, `pe`, `zeek`, `json`.
* `lc-payload-id` if present, this is a globally unique identifier for the artifact file. It can be used to ingest artifacts in an idempotent way, meaning a second file ingested with this same value will be ignore.
* `lc-path` if present, should be a base-64 encoded string representing the original file path of the artifact on the source system.
* `lc-part` if present, is used to track multi-part artifact uploads. If set, it should be an integer starting at `0` and incrementing for every part with the last part being set to `done`. The `lc-payload-id` MUST be set and constant across all parts.

## Accessing Artifacts
There are several ways to access the artifacts.

The main page contains a link to
"Artifact Collection" which displays all logs files ingested in the last week. From
there you can select a specific log and view it.

The search page contains a switch to search "in artifacts" instead of sensors. When
you search for an indicator, enabling this switch will return you all the hits
from the artifact files you have previously ingested.

The historical view has a button that appears in the top left of the page after
a search. Click it will list all log files received from that sensor during that
time period and will allow you to go view them. Finally, from the same page, when
viewing the details of a specific event, right-clicking on an indicator and clicking
"Find Other Locations" will bring you a search interface where you can also search
for "in artifact".

## Windows Event Logs
When running D&R rules against Windows Event Logs (`target: artifact` and `artifact type: wel`), although the [Artifact Collection Service](external_logs.md) may ingest
the same Windows Event Log file that contains some records that have already been processed by the rules, the LimaCharlie platform will keep track of the
processed `EventRecordID` and therefore will NOT run the same D&R rule over the same record multiple times.

This means you can safely set the [Artifact Collection Service](external_logs.md) to collect various Windows Event Logs from your hosts and run D&R rules over them
without risking producing the same alert multiple times.

For most Windows Event Logs available, see `c:\windows\system32\winevt\logs\`.