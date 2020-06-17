# Zeek

[TOC]

## Overview
The Zeek service allows you to run [Zeek](https://zeek.org/) on PCAP files in the
[Artifact Collection](external_logs.md) system. The resulting log files from Zeek
are then re-ingested into the same system where they will be parsed as JSON and
where [D&R rules](dr.md) can be created to automate detection and response.

### Common Trigger
Zeek is most commonly used as part of a D&R rule to automatically run on newly
ingested PCAP files. This is an example of a rule that runs on all PCAPs:

**Detect**
```yaml
op: exists
event: ingest
log type: pcap
path: /
target: artifact_event
```

**Respond**
```yaml
- action: service request
  name: zeek
  request:
    action: run_on
    artifact_id: <<routing/log_id>>
    retention: 90
```

### run_on
The `run_on` action is the main command supported by the Zeek Service. It can
run in 1 of 2 modes:

1. Run on a single PCAP file (referenced by `artifact_id`).
1. Run on a set of PCAP files filtered by Source, Filter Expression and start/end times.

### REST

#### run_on
```
{
  "action": "run_on",
  "artifact_id": "1111-2222-3333",
  "source": "4444-5555-6666",
  "filter": "any=tcp port 80",
  "start": 1592312707,
  "end": 1592322707,
  "retention": 30
}
```

The `retention` parameter is the number of days the resulting Zeek logs
should be retained in LimaCharlie.