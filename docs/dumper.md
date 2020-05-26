# Dumper

[TOC]

## Overview
The Dumper service provides the ability to do full memory dumping of Windows hosts..

It supports a single action, which is to dump the memory of the host and automates the ingestion
of the resulting dump and dump metadata to LimaCharlie's [Artifact Collection](external_logs.md)
artifact storage where it can be downloaded or analyzed.

### REST

#### Dumping
```
{
  "sid": "70b69f23-b889-4f14-a2b5-633f777b0079"
}
```
