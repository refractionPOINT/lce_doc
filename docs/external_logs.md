# External Logs

[TOC]

The External Logs system allows you to ingest external log types like:
* Plain Text Logs (syslog for example)
* Windows Event Logs
* PCAPs

Those logs can be ingested from hosts running a LimaCharlie sensor, or they
can be pushed to the LimaCharlie platform via a REST interface.

Once ingested, the logs are retained and made available to you for one year.
Ingested logs are also indexed similarly to LimaCharlie events. This means
that you can search all of your logs for the last year for Indicators like
IP Addresses, Domain Names, User Names, Hashes etc.

This in turn makes it possible for you to be looking at sensor data, identity
an IP of interest, and launch a quick search to see if this IP has been observed
in any logs over the past year. If it has, with one click you can visualize the
relevant log entries to assist you in your investigation.

We call this "log operationalization". It is not mean to be a general viewing
and querying tool like Splunk, but as a tactical tool providing you with critical
answers as you need them during security operations.

## Ingestion
### Using LC Sensors
To instruct the ingestion of a log file located on a host where LC is installed,
simply issue the [log_get](sensor_commands.md#log_get) command. You should receive
two events in response to this command: a general receipt indicating the sensor
received the command, and a response with a status code indicating whether the
ingestion was successful (an error code of `200` (as in HTTP) indicates success).

### Using the CLI
To simplify the task on ingesting via the REST API, you can use the LC CLI tool (`pip install limacharlie`).
Using this tool, you can use the `limacharlie-upload --help` command it installs.
This is the recommended way of ingesting logs from external systems where LC is not installed.

### Using the REST API
When the sensor is tasked to ingest a log file, it itself uses the REST API.

The REST API uses Ingestion Keys, which can be managed through the REST API
section of the LC web interface. Access to manage these Ingestion Keys requires
the `ingestkey.ctrl` permission.

The REST endpoint is located at a per-datacenter URL. You can query the relevant
URL for your organization using [this REST call](https://api.limacharlie.io/static/swagger/#/orgs/get_orgs__oid__url).

The endpoint is authenticated using Basic Authentication with the user name being
the Organization ID (OID) and the password the Ingestion Key, via a POST.

The body of the POST contains the log file to ingest. Additional metadata is provided
using the following Header fields:

* `lc-source` is a free form string used as an identifier of the origin of the log. When a log is ingested from a LC sensor, this value is the Sensor ID (SID) of the sensor.
* `lc-hint` if present, this indicates to the backend how the file should be interpreted. It default to `auto` which results in the backend auto-detecting the formal. Currently supported hints include `wel` (Windows Events Log), `pcap` and `txt`.
* `lc-payload-id` if present, this is a globally unique identifier for the log file. It can be used to ingest logs in an idempotent way, meaning a second log file ingested with this same value will be ignore.
* `lc-path` if present, should be a base-64 encoded string representing the original file path of the log on the source system.

## Accessing Logs
There are several ways to access the logs.

The main page contains a link to
"External Logs" which displays all logs files ingested in the last week. From
there you can select a specific log and view it.

The search page contains a switch to search "in logs" instead of sensors. When
you search for an indicator, enabling this switch will return you all the hits
from the log files you have previously ingested.

The historical view has a button that appears in the top left of the page after
a search. Click it will list all log files received from that sensor during that
time period and will allow you to go view them. Finally, from the same page, when
viewing the details of a specific event, right-clicking on an indicator and clicking
"Find Other Locations" will bring you a search interface where you can also search
for "in logs".