# Endpoint Detection & Response

LimaCharlie provides a true-real-time Endpoint Detection & Response (EDR) capability. Verbose telemetry is streamed from the endpoint sensor to the cloud in real-time over a semi-persistent TLS connection. Response actions are taken on the endpoint within 100ms of the triggering action or behaviour. 

Endpoint telemetry is ingested and analysed in-flight. Telemetry can be tested against thousands of rules without impacting performance.

LimaCharlie’s EDR sensor monitors a wide variety of [event data](./events.md) that is delivered in a common JSON format.

### Detection

A versatile YAML-based detection syntax can be used to create detections for highly sophisticated behaviour, including the ability to track state and build multi-step detection logic that runs at wire speed. 

This same detection syntax can also be used to easily achieve the following:

* Run Sigma rules
* Run continuous YARA scans without impacting performance
* Leverage threat feeds or lookups
* Check hashes against VirusTotal
* Create rules against telemetry from Windows Defender
* Check domains using Levenshtein distance to detect spear phishing

### Response

When a detection is triggered a response action is initiated. A response can take an action on the endpoint or be used to automate many aspects of security operations. Response actions can include:

* Kill a process or process tree
* Trigger memory dumps
* Issue an alert to a wide variety of destination types including the web application, any webhook, SMTP, PagerDuty, Kafka, SCP and more
* Initiate full PCAP capture from the network without impacting performance
* Trigger log ingestion and analysis
* Deploy and run any executable on endpoint such as patches or custom scripts

A repository of sample detection rules can be found in this repository: [Sample Rule Set](https://github.com/refractionPOINT/rules)

The full open source Sigma ruleset (which can be enabled on deployments at the click of a button) can be found here: [Sigma Rule Set](https://github.com/refractionPOINT/sigma)


## Architecture & OS Support

LimaCharlie provides the widest platform support industry-wide. The EDR sensor is written in C and then compiled for each different platform and architecture it runs on. With the exception of platform specific behaviours, the EDR sensor has feature parity across all operating systems and is IoT friendly with builds across x86, ARM and MIPS architectures.

The EDR sensor can run on the following operating systems across x86, ARM & MIPS architectures.

 * 32-bit Windows all way Back to Windows XP through to the most modern version of 64-bit Windows
 * All flavours of Linux both 32-bit and 64-bit
 MacOS
 * Docker containers
 * Builds for Solaris and BSD can be produced on [request](https://limacharlie.io/user-ticket)

Along with the core EDR sensor, LimaCharlie has a browser-based sensor that provides a subset of capabilities for Chromebooks, the Chrome browser and the Microsoft Edge browser.


## Technical Specs

The agent is approximately 500kb in size but that varies a little depending on which platform it is compiled for. While running it consumes less than 1% CPU but does spike very briefly when certain events take place, such as an application starting up. LimaCharlie is able to pack so much power into such a small program because it treats the agent as an extension of the cloud by utilizing a true real-time persistent TLS connection. The round trip time from an event being detected to the time a response is actioned on the endpoint is generally less than 100 milliseconds.

Documentation on deploying the agent can be [found here](./deploy_sensor.md).

The LimaCharlie agent installs a sensor which is fully interactive and can monitor over [70 different event types](./events.md).

## Telemetry & Retention

Telemetry sent to LimaCharlie is based on [events](./events.md) and is stored in its entirety in a one-year rolling buffer.

Telemetry uses the concept of [atoms](./events.md#atoms), and fine-grained control over what telemetry is sent up to the cloud can be managed using [exfil control](#exfil-control).

## Exfil Control

By default, LimaCharlie sensors send events to the cloud based on a standard profile that includes events like NEW_PROCESS, DNS_REQUEST etc. A complete list of events can be found [here](./events.md).

If you enable the Exfil Service, this default profile is replaced by a custom set of rules you define.

Details on using custom exfil can be found [here](./exfil.md).

## Outputs

LimaCharlie users can choose to send their data anywhere that they want.

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

## Installing the Agent

Installing the sensor requires administrator (or root) execution:

**Windows EXE:** ```installer.exe -i YOUR_INSTALLATION_KEY```

**Windows MSI:** ```installer.msi WRAPPED_ARGUMENTS="YOUR_INSTALLATION_KEY"```

**MacOS:** ```chmod +x installer ; installer -i YOUR_INSTALLATION_KEY```

**Linux:** ```chmod +x installer ; installer -d YOUR_INSTALLATION_KEY```

**Note:** On Linux the exact persistence mechanism, like launchd, is left to the administrator, therefore the ```-d``` argument launches the sensor from the current working directory without persistence. The sensor does not daemonize itself.

**Note:** A sample installer script is [available here](https://github.com/refractionPOINT/lce_doc/blob/master/docs/lc_linux_installer.sh) that works on Debian and CentOS families.

**Chrome(+OS):** See our [documentation here]()


**Docker:** See our [documentation here]()

## Connectivity

**Agent to cloud:** agents require access over port 443 using pinned SSL certificates (SSL interception is not supported)

**Chrome Agent to cloud:** agents require access over port 443 using normal SSL certificates websockets

**Artifact Collection ingestion:** agents require access over port 443 to ingest artifact

**Replay API:** agents do NOT require access

## <span style="color:#3889c7">Updating Sensor Versions</span>

Upgrading sensors is done transparently when the user clicks a button in the web application or through the API/SDK/CLI. Rolling back sensor versions can also be done with the click of a button in the web application or through the API/SDK/CLI. You do not need to re-download installers (in fact the installer stays the same). Once an upgrade has been triggered the new version should be in effect across the organization within about 20 minutes.

## <span style="color:#3889c7">ARM Variants</span>

Deploying on ARM can sometimes be tricky. The various architectures and naming can be confusing. To help you with this
here are the cross-compiling toolchains used for the various ARM variants LimaCharlie supports:

**arm:** gcc-arm-linux-gnueabihf

**arm64:** gcc-aarch64-linux-gnu

**arml:** gcc-arm-linux-gnueabi

If you are targeting Raspberry Pi you likely want `arml`.

## <span style="color:#3889c7">Installer Downloads</span>

**Windows**

[Windows 32 bit](https://app.limacharlie.io/get/windows/32)

[Windows 64 bit](https://app.limacharlie.io/get/windows/64)

[Windows msi32](https://app.limacharlie.io/get/windows/msi32)

[Windows msi64](https://app.limacharlie.io/get/windows/msi64)

**MacOS**

[MacOS 64 bit](https://app.limacharlie.io/get/mac/64)

[MacOS pkg](https://app.limacharlie.io/get/mac/pkg)

**Linux**

[Linux 32 bit](https://app.limacharlie.io/get/linux/32)

[Linux 64 bit](https://app.limacharlie.io/get/linux/64)

[Linux alpine64](https://app.limacharlie.io/get/linux/alpine64)

[Linux arm32](https://app.limacharlie.io/get/linux/arm32)

[Linux arm64](https://app.limacharlie.io/get/linux/arm64)

[Linux arml](https://app.limacharlie.io/get/linux/arml)

[Docker](https://hub.docker.com/r/refractionpoint/limacharlie_sensor)

**Chrome/ChromeOS**

[Chrome](https://app.limacharlie.io/get/chrome/)
