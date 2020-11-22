
![image 'lc-marketplace'](./images/lc-marketplace.png)

LimaCharlie offers additional free and paid integrated services through it's Add-Ons Marketplace.



Add-Ons fall into one of several categories, each of which is linked below.


<details>
<summary>"Click to expand"</summary>
this is hidden
</details>

# Add-Ons

A current list of available Add-Ons is as follows:


## API

### insight

Insight provides storage, retention and searching of all data for up to one year.

Website: https://limacharlie.io/insight
Owner: ops@limacharlie.io
Cost: $0.5 USD / sensor
Platforms:    

---

### ip-geo

API to perform IP Geolocation. Data provided by https://maxmind.com.

Website: http://doc.limacharlie.io/en/master/dr/#ip-geolocation
Owner: ops@limacharlie.io
Cost: FREE
Platforms:    

---


### vt

VirusTotal is an online platform used to share potential malware samples and the related scan results from a multitude of Anti-Virus engines.

You can use the VirusTotal API as part of LimaCharlie D&R rules to obtain the number of Anti-Virus engines having flagged a specific file hash as malicious.

See the VirusTotal website for API keys: https://virustotal.com

Website: http://doc.limacharlie.io/en/master/dr/#virustotal
Owner: ops@limacharlie.io
Cost: FREE
Platforms:

---

## Services

###  cuttingedge

The Cutting Edge threat feeds are aggregated, filtered and augmented from a multitude of sources.

Emphasis is put on timely Indicators of Compromise (IoC) for new and upcoming threats.

Produced detections are made more powerful for operations by including a lot of metadata around the origin of the IoC as well as the nature of the threat which provides pre-emptive investigation data.

A "sentiment" metric is also included to help you dial in the level of certainty you want to receive alerts for.

Website: https://limacharlie.io
Owner: intelligence@refractionpoint.eu
Cost: $0.3 USD / sensor
Platforms:     
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, org.get

---

## dumper

On request, the dumper service will perform a full memory dump of a host and upload the resulting dumps to LimaCharlie's External Logs system and delete the local dumps afterwards.

Requests to the dumper service support two parameters: "sid" (a sensor ID where to perform the dump) and "retention" (optional number of days of retention to upload the memory dumps with.

The dumper service does not currently validate that the host has enough available disc space for the memory dump.

Although the dumper service is free, the resulting memory dumps uploaded to LimaCharlie are subject to External Logs pricing.

For an example of requesting a dump through a D&R rule, see the "service request" action

Website: https://limacharlie.io
Owner: ops@limacharlie.io
Cost: FREE
Platforms:  
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, org.get, payload.ctrl, payload.use, sensor.get, sensor.task
API Flair: lock, secret, segment

---

### exfil

Automates the management of event selection for the events from agents that should be sent to the cloud in real-time.

Website: https://doc.limacharlie.io/en/master/exfil/
Owner: ops@limacharlie.io
Cost: FREE
Platforms:

---

### generic-macos

Generic MacOS detections for suspicious behavior. Requires the Exfil service.

Website: https://limacharlie.io
Owner: ops@limacharlie.io
Cost: FREE
Platforms:  
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, fp.ctrl, org.get, replicant.get, replicant.task
API Flair: lock, secret, segment

---

### integrity

Automates management of the File/Registry integrity monitoring

Website: https://limacharlie.io
Owner: ops@limacharlie.io
Cost: FREE
Platforms:  
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, fp.ctrl, org.get, replicant.get, replicant.task
API Flair: lock, secret, segment

---

### logging

Automates various aspects of external log collection from endpoints.

Website: https://doc.limacharlie.io/en/master/external_logs/
Owner: ops@limacharlie.io
Cost: FREE
Platforms:

---

### otx

Continuously import all your OTX pulses and the relevant D&R rules for most indicator types. Set your OTX API key in the Integrations section and subscribe to this Service.

Website: https://otx.alienvault.com/
Owner: ops@limacharlie.io
Cost: $0.05 USD / sensor
Platforms:    
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, org.conf.get, org.get
API Flair: bulk, lock, secret, segment

---

### pagerduty

Trigger alerts with PagerDuty.

For more information: https://doc.limacharlie.io/docs/documentation/docs/pagerduty.md

Website: https://pagerduty.com
Owner: ops@limacharlie.io
Cost: FREE
Platforms:    
Permissions requested:
org.conf.get, org.get
API Flair: bulk, lock, secret, segment

---

### reliable-tasking

Enables reliable, asynchronous and large scale tasking of LimaCharlie sensors. This means you can send a task to a large number of sensors, including offline sensors. The service takes care of retrying to send the task to offline sensors to ensure each of the targeted sensors is tasked at least once. An optional expiry is available to stop retrying tasks after a given time period.

Website: https://limacharlie.io
Owner: ops@limacharlie.io
Cost: FREE
Platforms:    
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, job.set, org.get, sensor.get, sensor.list, sensor.task
API Flair: bulk, lock, secret, segment

---

### replay

Automates the Replay of various Detection & Response rules on historical sensor data.

Website: https://doc.limacharlie.io/en/master/replay/
Owner: ops@limacharlie.io
Cost: FREE
Platforms:

---

### responder

Automates various aspects of investigation and incident response.

Website: https://doc.limacharlie.io/en/master/responder/
Owner: ops@limacharlie.io
Cost: FREE
Platforms:

---

### sensor-cull

Automated sensor deletion upon an expiration time.

Ideal for cloud docker deployments of VM based deployments creating sensors in continuous fashion.

See documentation here: https://doc.limacharlie.io/en/master/sensor_cull/

Website: https://limacharlie.io
Owner: ops@limacharlie.io
Cost: FREE
Platforms:    
Permissions requested:
org.get, sensor.del, sensor.get, sensor.list
API Flair: bulk, lock, secret, segment

--- 

### sigma

This service provides a core set of the open source Sigma rules in managed fashion.

It provides hundreds of rules and is a great boiler-plate rule pack to apply to your LimaCharlie deployment.

Sigma is an open source format for describing signatures in a generic way so that they can be applied through multiple technologies (like LimaCharlie).

The Sigma project is avaialble here: https://github.com/Neo23x0/sigma

The specific rules, converted and applied through this service are available here: https://github.com/refractionPOINT/sigma/tree/lc-rules/lc-rules

Some Sigma rules on Windows rely on Windows Event Logs which are not collected by LimaCharlie by default. In order to leverage these you will need to configure automated collection of the relevant Windows Event Logs through the Artifact Collection service.

Website: https://limacharlie.io
Owner: ops@limacharlie.io
Cost: FREE
Platforms:  
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, org.get

---

### soteria-rules

Install a managed set of Detection & Response rules developed by Soteria.

The rules cover most common attacks on Windows, MacOS and Linux. When subscribing to this service, LimaCharlie will automate the installation and updating of the rules in an opaque way. You simply get the Detections containing information about the detected behavior.

Website: https://soteria.io
Owner: pihme@soteria.io
Cost: $0.5 USD / sensor
Platforms:    
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, fp.ctrl, org.get, sensor.tag
API Flair: bulk, lock, secret, segment

---

### twilio

Send messages using Twilio.

For more information: https://doc.limacharlie.io/docs/documentation/docs/twilio.md

Website: https://soteria.io
Owner: pihme@soteria.io
Cost: $0.5 USD / sensor
Platforms:    
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, fp.ctrl, org.get, sensor.tag
API Flair: bulk, lock, secret, segment

---

### yara

Automates management of Yara signature sets and their use in scanning.

Website: https://doc.limacharlie.io/en/master/yara/
Owner: ops@limacharlie.io
Cost: FREE
Platforms:    

---

### zeek

Once enabled, the Zeek service will watch for PCAP files being ingested through External Logs. For each PCAP, the Zeek service will run the Zeek tool (aka Bro) on the PCAP. All the resulting Zeek log files will then be re-ingested into External Logs where they can be viewed or Detection & Response rules can be created to generated detections or automate responses.

The Zeek service pricing is based on the size of PCAPs processed: $0.02 per 1GB.

Website: https://limacharlie.io
Owner: ops@limacharlie.io
Cost: Based on Usage
Platforms:    
Permissions requested:
ingestkey.ctrl, insight.evt.get
API Flair: lock, secret, segment

---

## Lookup

### alienvault-ip-reputation

Alienvault IP Reputation

Website: https://www.alienvault.com/
Owner: ops@limacharlie.io
Cost: FREE
Platforms:   

---

amnesty-international-mfa-phishing

Amnesty International reported a large campaigns of 2FA / MFA Phishing attacks in Middle East and North Africa

Website: https://goo.gl/ukmULf
Owner: gio@refractionpoint.com
Cost: FREE
Platforms:   

---

### 

---

### apt28-201810292203gmt

amnesty-international-mfa-phishing

Website: https://goo.gl/ukmULf
Owner: gio@refractionpoint.com
Cost: FREE
Platforms:   

---






---
---



## sigma

This service provides a core set of the open source Sigma rules in managed fashion.

It provides hundreds of rules and is a great boiler-plate rule pack to apply to your LimaCharlie deployment.

Sigma is an open source format for describing signatures in a generic way so that they can be applied through multiple technologies (like LimaCharlie).

The Sigma project is avaialble here: https://github.com/Neo23x0/sigma

The specific rules, converted and applied through this service are available here: https://github.com/refractionPOINT/sigma/tree/lc-rules/lc-rules

Some Sigma rules on Windows rely on Windows Event Logs which are not collected by LimaCharlie by default. In order to leverage these you will need to configure automated collection of the relevant Windows Event Logs through the Artifact Collection service.

---

## soteria-rules

Install a managed set of Detection & Response rules developed by Soteria.

The rules cover most common attacks on Windows, MacOS and Linux. When subscribing to this service, LimaCharlie will automate the installation and updating of the rules in an opaque way. You simply get the Detections containing information about the detected behavior.

Website: https://soteria.io
Owner: pihme@soteria.io
Cost: $0.5 USD / sensor
Platforms:    
Permissions requested:
dr.del.replicant, dr.list.replicant, dr.set.replicant, fp.ctrl, org.get, sensor.tag
API Flair: bulk, lock, secret, segment

---

## zeek

Once enabled, the Zeek service will watch for PCAP files being ingested through External Logs. For each PCAP, the Zeek service will run the Zeek tool (aka Bro) on the PCAP. All the resulting Zeek log files will then be re-ingested into External Logs where they can be viewed or Detection & Response rules can be created to generated detections or automate responses.

The Zeek service pricing is based on the size of PCAPs processed: $0.02 per 1GB.

Website: https://limacharlie.io
Owner: ops@limacharlie.io
Cost: Based on Usage
Platforms:    
Permissions requested:
ingestkey.ctrl, insight.evt.get
API Flair: lock, secret, segment

---



