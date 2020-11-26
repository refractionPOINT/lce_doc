<!-- leave the empty title here... the image below displays the info BUT the platform requires something here -->
# 

![image 'lc-output'](https://storage.googleapis.com/limacharlie-io/brand/logo/lc-output.png)

The data produced by the LimaCharlie endpoint is under complete control of the user. LimaCharlie provides extensive storage and search options as part of its core offering but makes the full telemetry stream availble to users.

## <span style="color:#605142">Exfil Control</span>

By default, LimaCharlie sensors send events to the cloud based on a standard profile that includes events like NEW_PROCESS, DNS_REQUEST etc.

If you enable the Exfil Service, this default profile is replaced by a custom set of rules you define.

Details on using custom exfil can be found [here](./exfil.md).


## <span style="color:#605142">Outputs</span>

LimaCharlie users own their data and can send it anywhere they want. 

The following output methods are currently availble with a general overview [here](./outputs.md). If you have any special needs around output methods please file a ticket [here](https://limacharlie.io/user-ticket).

* [Amazon S3](./outputs.md#amazon-s3)
* [Google Cloud Storage](./outputs.md#google-cloud-storage)
* [SCP](./outputs.md#scp)
* [Slack](./outputs.md#slack)
* [Syslog (TCP)](./outputs.md#syslog-tcp)
* [Webhook](./outputs.md#webhook)
* [Webhook Bulk](./outputs.md#webhook-bulk)
* [SMTP](./outputs.md#smtp)
* [Humio](./outputs.md#humio)
* [Kafka](./outputs.md#kafka)
* [Splunk](./outputs.md#splunk)

## <span style="color:#605142">Integrations</span>

LimaCharlie makes sharing data with certain even easier by offering built in integrations.

### <span style="color:#605142">Virus Total</span>

Analyze suspicious files and URLs to detect types of malware, automatically share them with the security community

Product website [here](https://www.virustotal.com/gui/).

### <span style="color:#605142">AlienVault OTX</span>

Open Threat Exchange is the neighborhood watch of the global intelligence community. It enables private companies, independent security researchers, and government agencies to openly collaborate and share the latest information about emerging threats, attack methods, and malicious actors, promoting greater security across the entire community

Product website [here](https://otx.alienvault.com/).

### <span style="color:#605142">Web App Domain</span>

Allows users to enter ther custom domain used for LimaCharlie whitelabel partners.

For information about becoming a whitelabel partner [contact us](https://limacharlie.io/user-ticket).

### <span style="color:#605142">Shodan</span>

Shodan provides a public API that allows other tools to access all of Shodan's data. Integrations are available for Nmap, Metasploit, Maltego, FOCA, Chrome, Firefox and many more.

Product website [here](https://www.shodan.io/).

### <span style="color:#605142">Shodan</span>


Shodan provides a public API that allows other tools to access all of Shodan's data. Integrations are available for Nmap, Metasploit, Maltego, FOCA, Chrome, Firefox and many more.

Product website [here](https://www.shodan.io/).

### <span style="color:#605142">PagerDuty</span>

PagerDuty is intgrated with LimaCharlie and can be used for alerting analysts using advanced step-wise notification system. Get the people you need without buggin the ones you don't.

Product website [here](https://www.pagerduty.com/).

### <span style="color:#605142">Twilio</span>

Twilio is intgrated with LimaCharlie and can be used for alerting analysts using advanced step-wise notification system. Get the people you need without buggin the ones you don't.

Product website [here](https://www.twilio.com/).

### <span style="color:#605142">Security Onion</span>

A great guide for integrating LimaCharlie into [Security Onion](https://securityonion.net/) is available [here](https://medium.com/@wlambertts/security-onion-limacharlie-befe5e8e91fa) along with the code [here](https://github.com/weslambert/securityonion-limacharlie/).