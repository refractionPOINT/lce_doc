#

![image 'lc-storage'](https://storage.googleapis.com/limacharlie-io/brand/logo/lc-storage.png)

By default LimaCharlie stores a full year of searchable endpoint telemetry as well as log files, binary assets and more.

All files and telemetry ingested are indiexed across common indicators of compromise and are easily processed by any of the subsystems or products in the LimaCharlie offering.

## <span style="color:#666fa5">Telemetry Storage</span>
 
Telemetry sent to the LimaCharlie is based on [events](./events.md) and is stored in its entirety in a one-year rolling buffer.

Telemetry uses the concept of [atoms](./events.md#atoms) and fine-grained control over what telemetry is sent up to the cloud can be managed using [exfil control](#exfil-control).

## <span style="color:#666fa5">Artifact Collection</span>
 
The Artifact Collection system allows you to ingest artifact types like:

* Plain text logs (syslog for example)
* Windows Event Logs
* PCAPs
* Windows Prefetch files
* Windows PE (executables) files
* Zeek (previously Bro)
* Full memory dumps
* Generic JSON
* OLE (MS Word, Excel etc)
* Windows MFT CSV Listing

Those artifacts can be ingested from hosts running a LimaCharlie sensor, or they can be pushed to the LimaCharlie platform via a REST interface.

Once ingested, the artifacts are retained and made available to you with a custom retention period. Ingested artifacts are also indexed similarly to LimaCharlie events. This means that you can search all of your artifact for the last year for Indicators like IP Addresses, Domain Names, User Names, Hashes etc.

This in turn makes it possible for you to be looking at sensor data, identity an IP of interest, and launch a quick search to see if this IP has been observed in any artifacts over the past year. If it has, with one click you can visualize the relevant artifact entries to assist you in your investigation.

We call this "artifact operationalization". It is not mean to be a general viewing and querying tool like Splunk, but as a tactical tool providing you with critical answers as you need them during security operations.

**Note:** that Artifact Collection configurations are synchronized with sensors every few minutes.

Details on Artifact Collection and how to utilize it can be found [here](./external_logs.md).

## <span style="color:#666fa5">Exfil Control</span>

By default, LimaCharlie sensors send events to the cloud based on a standard profile that includes events like NEW_PROCESS, DNS_REQUEST etc.

If you enable the Exfil Service, this default profile is replaced by a custom set of rules you define.

Details on using custom exfil can be found [here](./exfil.md).

## <span style="color:#666fa5">Historical Threat Hunting</span>

 Details outlining methods for hunting threats across historical telemetry can be found in the [lc-hunt](./images/lc-hunt.md) section of the documentation.