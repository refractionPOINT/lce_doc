# Ingesting Windows Event Logs in Real-Time

Along with [Log & Artifact Ingestion](./external_logs.md), LimaCharlie can ingest Window Event Logs in real-time.

## From Real-Time Events
\* *Only supported on Windows 2008 and up*

It is possible to subscribe to receive Windows Event Logs in real-time from the sensor. By doing this, the targeted Windows Events will be sent to the cloud as normal LimaCharlie telemetry events encapsulated in an event type of WEL. The Windows Events in those cases will be structured as JSON similarly to other LimaCharlie telemetry. This means you can create D&R rules that operate directly on Windows Events, or even correlate between Windows Events and native LimaCharlie telemetry events.

To configure this collection, you need to specify a special kind of log path as a collection pattern. The format is as follows:

`wel://EventSource:FilterExpression`

The `wel://` prefix tells LimaCharlie this is not a file at rest, but a live API request from the sensor. The `EventSource` part of the expression refers to the `ChannelPath` described in the Windows documentation here: [docs.microsoft.com/en-us/windows/win32/api/winevt/nf-winevt-evtsubscribe](https://docs.microsoft.com/en-us/windows/win32/api/winevt/nf-winevt-evtsubscribe). The `FilterExpression` component refers to the `Query` parameter described in the same documentation. Additional documentation on the filter format can also be found here: [docs.microsoft.com/en-us/windows/win32/wes/consuming-events](https://docs.microsoft.com/en-us/windows/win32/wes/consuming-events).

Examples of supported patterns:

* `wel://Security:*`
* `wel://System:Event[System[EventID=4624]]`

## From Files at Rest

When running D&R rules against Windows Event Logs (`target: artifact` and `artifact type: wel`) that were acquired from files at rest, although the Artifact Collection Service may ingest the same Windows Event Log file that contains some records that have already been processed by the rules, the LimaCharlie platform will keep track of the processed `EventRecordID` and therefore will NOT run the same D&R rule over the same record multiple times.

This means you can safely set the Artifact Collection Service to collect various Windows Event Logs from your hosts and run D&R rules over them without risking producing the same alert multiple times.

For most Windows Event Logs available, see `c:\windows\system32\winevt\logs\`.