---
title: Billing
slug: billing
---

# Billing

## Overview
Billing in LimaCharlie is done on monthly cycles and per-Organization (multi-tenant).

Some features like centralized billing are available to larger LC users like MSSPs, if
you would like more details contact us at sales@limacharlie.io.

For exact pricing see the [LimaCharlie website](https://limacharlie.io) or [Web App](https://app.limacharlie.io).

## Services

### Endpoints (EDR)
The EDR service is the foundation of LimaCharlie. In order to make billing
simpler and more predictible, it is based on a Quota set by the user.

The Quota is the number of sensors (agents) concurrently online that should be 
supported by the given Organization. The Quota applies to concurrently onlie sensors
meaning that you may have more sensors registered than your quota.

If sensors attempt to connect to the cloud while the Quota is full, they will simply
be turned away for a short period of time. In that case, a special [sensor_over_quota](events.md#sensor_over_quota)
will also be emitted which you can use in [D&R rules](dr.md) for automation.

The endpoint service includes [Outputs](outputs.md) as well as [D&R rules](dr.md) processed
in real-time.

#### Sidecar Sensors
A special case around Quota use is called Sidecar Sensors. At the moment the only
Sidecar Sensor is the Chrome sensor. A Sidecar Sensor will not count against your
Quota as long as it has a correspondant "normal" sensor.

For example, let's say you have 10 Windows sensors and 10 MacOS sensors online for
a total of 20 "normal" sensors. This means you will be able to have up to 20 other
Chrome sensors online without using any extra quota. If 25 Chrome sensors become
online however, 5 extra Quota will be consumed.

The intent is to allow Chrome sensors to be companion sensors enhancing visibility
of your existing LimaCharlie deployment without making Chrome-only deployments
effectively free.

### Insight (Retention)
Insight is also a foundational service of LimaCharlie. It provides a flat 1 year of
full retention (full telemetry) for a single price in order to make billing more
predictible.

### Replay (Retroactive Scanning)
[Replay](replay.md) allows you to run [D&R rules](dr.md) against external or historical telemetry.
Not to be confused with Searching for specific IoCs which is a free feature of Insight.

Its pricing is based on two factors:

1. The Complexity of the D&R rule.
1. The number of events (telemetry) to be replayed.

The metric used for billing is a combination these two factors: "number of operation evaluations".

A rule with a single [operator](dr.md#operators) like this:

```yaml
op: ends with
path: event/FILE_PATH
value: evil.exe
```

replayed against 100 events would result into 100 "operation evaluations".

Final billing is based on blocks of those "operation evaluations".

The best way to evaluate the cost of a specific rule through Replay is to
launch a limited Replay job of a given rule first. The results of the job
will contain the number of operation evaluations performed. You can then
extrapolate an estimate of the cost.

Replay jobs can also be launched with a maximum number of operation evaluations
to consume during the life-cycle of the job. This limit is aproximate due to
the de-centralized nature of Replay jobs and may vary a bit.

### Artifact Collection
The [Artifact Collection service](external_logs.md) allows you to ingest artifacts
like Syslogs, Windows Events Logs as well as more complex file formats like
Packet Captures (PCAP), Windows Prefetch files, Portable Executable (PE) etc.

Ingested files can then be downloaded as originals or viewed in parsed formats
right from your browser. You can also run [D&R rules](dr.md) against them.

Unlike Insight, the retention period is variable based on a number of days (up to 365)
as specified by the user at ingestion time.

All billing for it is done at ingestion time based on the number of days and the
size of the file. The billing metric is therefore "byte-days".

For example, a file that is 100 MB and is ingested with a retention period of
10 days would be one-time billed for `100 X 10 MB-days`. 