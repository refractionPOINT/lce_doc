# Bulk Logs

[TOC]

LimaCharlie provides the ability to process external log formats.
When doing so, LC will parse the logs and extract Indicators and index them.
This will in turn allow you to search and correlate Indicators across not
only the data from your endpoints, but also external log sources
like Windows Event Logs, Syslog, Webserver logs and security appliance logs.

## Ingestion
There are two main ways to get logs onto LimaCharlie.

The first is to enable the Logging Replicant, which then allows you to issue
the [log_get](sensor_commands.md#log_get) command to a sensor to get a local file. This turns LC into
its own customizable and automatable log aggregation system.

The second is to use the REST ingestion API directly. The best way to do this
is to use the LimaCharlie CLI (`pip install limacharlie`) with the
command `limacharlie-upload` which takes care of managing the POST to
our REST interface. This method allows you to automate the ingestion of logs
from assets that do not run a LimaCharlie sensor.

## Concepts
Here are some concepts as they relate to external logs:

* Source: this is a field you can set during ingestion to identify the entity
ingesting the log. When ingesting from a LimaCharlie, this field is the
Sensor ID (SID).
* Type: this is the type of log. Many values are supported. When set to `auto`
(the default) this will let LimaCharlie try to identify the type automatically.
This is typically good for simple text logs or very unique logs like Windows Event Logs.
The `opaque` format tells LimaCharlie not to try to parse or understand the log
and is meant to be used for custom file types. The most common format is `txt` which
represents simple newline-delimited log files, `wel` for Windows Event Logs and
`pcap` for Packet Capture files.
* Indexed: this indicates if the file could be parsed and indexed for search and visualization.
* Payload ID: this is a text identifier that can be provided at ingestion time
to unique identify the log. By default a UUID is generated, but it can be used
to ingest logs files in an idempotent way.

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