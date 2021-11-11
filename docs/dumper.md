# Dumper

## Overview
The Dumper service provides the ability to do dumping of several forensic artifacts on Windows hosts..

It supports a single action, which is to dump.
It supports multiple targets, `memory` to dump the memory of the host and `mft` to dump
the MFT of the filesytem to CSV.

The Service then automates the ingestion
of the resulting dump and dump metadata to LimaCharlie's [Artifact Collection](external_logs.md)
artifact storage where it can be downloaded or analyzed and where you can create D&R rules to automate
detections of characteristics of those dumps.

### REST

#### Dumping
```json
{
  "sid": "70b69f23-b889-4f14-a2b5-633f777b0079",
  "target": "memory",
  "retention": 7,
  "ignore_cert": false
}
```
