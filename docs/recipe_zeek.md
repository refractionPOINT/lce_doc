# Recipe - Zeek

[TOC]

## Overview
This recipe will show you how to use various features of LimaCharlie in order to do
network capture, process those network captures with [Zeek/BRO](https://zeek.org/) and
apply simple [Detection & Response](dr.md) rules on the Zeek logs.

At a high level, these will be the steps we'll take:

1. Automate network capture on a Linux endpoint.
1. Automate the processing through Zeek.
1. Create D&R rules for the Zeek logs.

## Step 1: Network Capture
Network telemetry is ingested in LimaCharlie through the Artifact Collection system.

Packet captures can be acquired in one of two ways:

1. Using the Artifact Collection's [REST API or the SDK's CLI](external_logs.md).
1. By configuring capture directly through a LimaCharlie endpoint.

For this recipe, we'll show you how to use method 2 since it's the easiest to get
started with.

In the LimaCharlie web app, go to the Artifact Collection section of your organization.

Towards the bottom of the page you'll find "PCAP Collection Rules". These rules define where
and how to capture network traffic. Each rule has a few components:

* Platforms: this where you select which platform this rule should apply to.
* Tags: specifies that this rule should only apply to endpoints that have all these tags applied to them.
* Retention: the number of days that the raw network captures should be retained by LimaCharlie.
* Patterns: this is the list of capture expressions describing which parts of the network to capture.
  * Interface: specifies which network interface should be captured.
  * Filter: this is the filter expression (tcpdump format) of the traffic to capture.

For this recipe, we'll use the following rule:

* Platform: Linux
* Tags: ***leave empty***
* Retention: `7`
* Patterns:
  * Interface: `any`
  * Filter: `tcp port 80`

The above rule will result in all network traffic on tcp port 80 (HTTP) getting captured regardless
of the network interface and will be retained for 7 days.

Once created, the relevant endpoints will be tasked to collect the network traffic. As enough network
data is collected, it will be uploaded to LimaCharlie. When ingested, these packet captures (PCAP)
will show up at the bottom of the Artifact Collection page.

## Step 2: Zeek Processing
Now that we have PCAPs making it into LimaCharlie, we'll want to run the Zeek service over those PCAPs.

To do this, we'll use the [D&R Rules](dr.md). When an Artifact is ingested in LimaCharlie, it generates
a synthetic event of type `ingest` that looks [like this](events.md#ingest).

So what we want is to execute a Service in reaction to an ingested Artifact of type `pcap`.

Head over to the D&R Rules section of the web app. Create a new rule and set it (in the advanced section)
to this yaml:

**Detection**:
```yaml
target: artifact_event
event: ingest
artifact type: pcap
op: exists
path: /
```

**Response**:
```yaml
- action: service request
  name: zeek
  request:
    action: run_on
    artifact_id: <<routing/log_id>>
    retention: 90
```

So what's going on here?

First the Detection component.
It says to target the `artifact_event` system (as opposed to the default `edr` system).
Then it specifies to look for events of type `ingest`, meaning that a new Artifact has been ingested.
Finally, we specify to only use events where the log type is `pcap` since Artifacts could be anything from PCAPs to Windows Event Logs or syslogs.
The last components simply say that we don't really care about the contents of the event, just knowing that the
event occured is enough for us to want to "match" and take action according to the Response component of the rule.

The Response component is telling LimaCharlie what to do when the Detection "matches". In our case, we want
to make a request to the `zeek` service to run over the PCAP. The `request` component of the Response here
is the data included to the Zeek service, in this case we want to ask zeek to run specifically over the "log"
with ID equal to the value in the `routing/log_id` of the `ingest` / `artifact_event` and to retain the resulting
Zeek logs for 90 days.

As you can now see, this recipe aims to retain the raw full PCAPs for 1 week, but the Zeek logs for 3 months since
the Zeek logs will be much smaller than the full PCAP.

Once you create this rule, any time a PCAP comes in, Zeek will run over it. The resulting Zeek logs will be
themselves re-ingested as Artifacts. This means you will be able to find them in the Artifact Collection section
of the web app.

## Step 3: Alerting on Zeek Logs
Now that the Zeek logs are ingested as Artifacts, it means we can write rules over them.

When we do this, it's important to understand how the Zeek logs will be interpreted for the D&R rules.
All Artifacts see the D&R rules engine evaluate them one "record" at a time. A "record" will depend on the
exact Artifact type. For PCAPs, a record is a single packet, for Syslog, a record is a log line. For Zeek
a record is also a log line.

Zeek logs are interpreted as first-class formats in LimaCharlie. This means that they're not simply treated
as text (although the original text logs are always kept and available). The Zeek logs get parsed and converted
to JSON automatically. This well-parsed format is what allows you to make D&R rules that are precise and don't
rely on messy regular expressions.

To see what the D&R rules will process exactly, go to the Artifact Collection section of the web app, find a
Zeek log entry at the bottom and click on the little "window expand" green icon for that log. This will open
in a new tab the contents of the Zeek log, as parsed by LimaCharlie. You'll see it's a list of JSON records.
This means that when we build our D&R rule, we want to describe how to match a JSON record.

Let's make our D&R rule:

**Detection**:
```yaml
target: artifact
artifact type: zeek
op: is
path: "id.orig_p"
value: "23"
```

**Response**:
```yaml
- action: report
  name: outbound connection from telnet port
```

This rule is quite simple:

Detect any record from a `zeek` type `artifact` that has a `id.orig_p` key with a value of `"23"`.
This is a field from a Zeek log's `conn.log` file that contains the originating port of a connection.

The Response simply states to `report` (alert) with a name of `outbound connection from telnet port`.

## Conclusion
That's it, from this point on, we'll alert on automatically collect network data, retain it, process it
with Zeek, retain those Zeek logs and alert on those logs as well.