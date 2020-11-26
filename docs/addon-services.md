## <span style="color:#185000">dumper</span>

**Cost:** FREE 

**Platforms:** Windows

**Permissions Requested:** dr.del.replicant, dr.list.replicant, dr.set.replicant, org.get, payload.ctrl, payload.use, sensor.get, sensor.task

API Flair: lock, secret, segment

>On request, the dumper service will perform a full memory dump of a host and upload the resulting dumps to >LimaCharlie's External Logs system and delete the local dumps afterwards.
>
>Requests to the dumper service support two parameters: "sid" (a sensor ID where to perform the dump) and >"retention" (optional number of days of retention to upload the memory dumps with.
>
>The dumper service does not currently validate that the host has enough available disc space for the memory dump.
>
>Although the dumper service is free, the resulting memory dumps uploaded to LimaCharlie are subject to External Logs pricing.
>
>For an example of requesting a dump through a D&R rule, see the "service request" action

## <span style="color:#185000">exfil</span>

**Website:** https://doc.limacharlie.io/en/master/exfil/

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows

>Automates the management of event selection for the events from agents that should be sent to the cloud in real-time.

# <span style="color:#185000">generic-macos</span>

**Cost:** FREE

**Platforms:** MacOS

**Permissions Requested:** dr.del.replicant, dr.list.replicant, dr.set.replicant, fp.ctrl, org.get, replicant.get, replicant.task

**API Flair:** lock, secret, segment

>Generic MacOS detections for suspicious behavior. Requires the Exfil service.

## <span style="color:#185000">integrity</span>

**Cost:** FREE

**Platforms:** MacOS, Windows

Permissions requested: dr.del.replicant, dr.list.replicant, dr.set.replicant, fp.ctrl, org.get, replicant.get, replicant.task

**API Flair:** lock, secret, segment

>Automates management of the File/Registry integrity monitoring

## <span style="color:#185000">logging</span>

**Website:** https://doc.limacharlie.io/en/master/external_logs/

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows

>Automates various aspects of external log collection from endpoints.

## <span style="color:#185000">otx</span>

**Website:** https://otx.alienvault.com/

**Cost:** $0.05 USD / sensor

**Platforms:** MacOS, Linux, Windows

**Permissions Requested:** dr.del.replicant, dr.list.replicant, dr.set.replicant, org.conf.get, org.get

**API Flair:** bulk, lock, secret, segment

>Continuously import all your OTX pulses and the relevant D&R rules for most indicator types. Set your OTX API key in the Integrations section and subscribe to this Service.

## <span style="color:#185000">pagerduty</span>

**Website:** https://pagerduty.com

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows

**Permissions Requested:** org.conf.get, org.get

**API Flair:** bulk, lock, secret, segment

>Trigger alerts with PagerDuty.
>
>For more information: https://doc.limacharlie.io/docs/documentation/docs/pagerduty.md

## <span style="color:#185000">reliable-tasking</span>

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows    

**Permissions Requested:** dr.del.replicant, dr.list.replicant, dr.set.replicant, job.set, org.get, sensor.get, sensor.list, sensor.task

**API Flair:** bulk, lock, secret, segment

>Enables reliable, asynchronous and large scale tasking of LimaCharlie sensors. This means you can send a task to a large number of sensors, including offline sensors. The service takes care of retrying to send the task to offline sensors to ensure each of the targeted sensors is tasked at least once. An optional expiry is available to stop retrying tasks after a given time period.

## <span style="color:#185000">replay</span>

**Website:** https://doc.limacharlie.io/en/master/replay/

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows

>Automates the Replay of various Detection & Response rules on historical sensor data.

## <span style="color:#185000">responder</span>

**Website:** https://doc.limacharlie.io/en/master/responder/

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows

>Automates various aspects of investigation and incident response.

## <span style="color:#185000">sensor-cull</span>

**Website:** https://limacharlie.io

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows

**Permissions Requested:** org.get, sensor.del, sensor.get, sensor.list

**API Flair:** bulk, lock, secret, segment

>Automated sensor deletion upon an expiration time.
>
>Ideal for cloud docker deployments of VM based deployments creating sensors in continuous fashion.
>
>See documentation here: https://doc.limacharlie.io/en/master/sensor_cull/

## <span style="color:#185000">sigma</span>

**Cost:** FREE

**Platforms:** Windows

**Permissions Requested:** dr.del.replicant, dr.list.replicant, dr.set.replicant, org.get

>This service provides a core set of the open source Sigma rules in managed fashion.
>
>It provides hundreds of rules and is a great boiler-plate rule pack to apply to your LimaCharlie deployment.
>
>Sigma is an open source format for describing signatures in a generic way so that they can be applied through multiple technologies (like LimaCharlie).
>
>The Sigma project is avaialble here: https://github.com/Neo23x0/sigma
>
>The specific rules, converted and applied through this service are available here: https://github.com/refractionPOINT/sigma/tree/lc-rules/lc-rules
>
>Some Sigma rules on Windows rely on Windows Event Logs which are not collected by LimaCharlie by default. In order to leverage these you will need to configure automated collection of the relevant Windows Event Logs through the Artifact Collection service.

## <span style="color:#185000">twilio</span>

**Website:** https://twilio.com

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows

**Permissions Requested:** org.conf.get, org.get

**API Flair:** bulk, lock, secret, segment

>Send messages using Twilio.
>
>For more information: https://doc.limacharlie.io/docs/documentation/docs/twilio.md

## <span style="color:#185000">yara</span>

**Website:** https://doc.limacharlie.io/en/master/yara/

**Owner:** ops@limacharlie.io

**Cost:** FREE

**Platforms:** MacOS, Linux, Windows

>Automates management of Yara signature sets and their use in scanning.

## <span style="color:#185000">zeek</span>

**Website:** https://limacharlie.io

**Owner:** ops@limacharlie.io

**Cost:** Based on Usage

**Platforms:** MacOS, Linux, Windows

**Permissions Requested:** ingestkey.ctrl, insight.evt.get

**API Flair:** lock, secret, segment

>Once enabled, the Zeek service will watch for PCAP files being ingested through External Logs. For each PCAP, the Zeek service will run the Zeek tool (aka Bro) on the PCAP. All the resulting Zeek log files will then be re-ingested into External Logs where they can be viewed or Detection & Response rules can be created to generated detections or automate responses.
>
>The Zeek service pricing is based on the size of PCAPs processed: $0.02 per 1GB.