# LimaCharlie Adapter

The LimaCharlie Adapter can be used to ingest external data streams from many different technologies including:

* Syslog
* AWS S3
* Google Cloud Pubsub
* STDIN

## Usage

The adapter can be used to access many different sources and many different event types. The main mechanisms specifying the source and type of events are:

1. Adapter Type: this indicates the technical source of the events, like syslog or S3 buckets.
1. Platform: the platform indicates the type of events that are acquired from that source, like text or carbon_black.

Depending on the Adapter Type specified, configurations that can be specified will change. Running the adapter with no command line arguments will list
all available Adapter Types and their configurations.

Configurations can be provided to the adapter in one of three ways:

1. By specifying a configuration file.
1. By specifying the configurations via the command line in the format `config-name=config-value`.
1. By specifying the configurations via the environment variables in the format `config-name=config-value`.

All Adapter Types support the same `client_options`, plus type-specific configurations. You should always specify the following configurations:

* `client_options.identity.oid`: the LimaCharlie Organization ID (OID) this adapter is used with.
* `client_options.identity.installation_key`: the LimaCharlie Installation Key this adapter should use to identify with LimaCharlie.
* `client_options.platform`: the type of data ingested through this adapter, like `text`, `json`, `gcp` or `carbon_black`.
* `client_options.sensor_seed_key`: an arbitrary name for this adapter which Sensor IDs (SID) are generated from, see below.

Other common configurations that are not required include:

* `client_options.mapping.parsing_re`: regular expression with [named capture groups](https://github.com/StefanSchroeder/Golang-Regex-Tutorial/blob/master/01-chapter2.markdown#named-matches). The name of each group will be used as the key in the converted JSON parsing.
* `client_options.mapping.sensor_key_path`: indicates which component of the events represent unique sensor identifiers.
* `client_options.mapping.sensor_hostname_path`: indicates which component of the event represents the hostname of the resulting Sensor in LimaCharlie.
* `client_options.mapping.event_type_path`: indicates which component of the event represents the Event Type of the resulting event in LimaCharlie.
* `client_options.mapping.event_time_path`: indicates which component of the event represents the Event Time of the resulting event in LimaCharlie.
* `client_options.mapping.rename_only`: if true, indicates the field mappings defined here should only be renamed fields from the original event (and not completely replacing the original event).
* `client_options.mapping.mappings`: a list of field remapping to be performed:
  * `src_field`: the source component to remap.
  * `dst_field`: what the SourceField should be mapped to in the final event.

All other configurations in `client_options` should only be set for advanced ingestion schemes.

## Sensor IDs
USP Clients generate LimaCharlie Sensors at runtime. The ID of those sensors (SID) is generated based on the Organization ID (OID) and the Sensor Seed Key.

This implies that if want to re-key an IID (perhaps it was leaked), you may replace the IID with a new valid one. As long as you use the same OID and Sensor Seed Key, the generated SIDs will be stable despite the IID change.

## Custom Formatting
Data sent via USP can be formatted in many different ways. Data is processed in a specific order as a pipeline:
1. Regular Expression with named capture groups parsing a string into a JSON object.
1. Built-in (in the cloud) LimaCharlie parsers that apply to specific `Platform` values (like `carbon_black`).
1. The various "extractors" defined, like `EventTypePath`, `EventTimePath`, `SensorHostnamePath` and `SensorKeyPath`.
1. Custom `Mappings` directives provided by the client.


## Examples

### Syslog
Start the container listening for Syslog. This example uses the syslog from a Debian box.
```
docker run --rm -it -p 4444:4444 usp-adapters syslog port=4444 client_options.identity.installation_key=e9a3bcdf-efa2-47ae-b6df-579a02f3a54d client_options.identity.oid=8cbe27f4-bfa1-4afb-ba19-138cd51389cd client_options.platform=text "client_options.mapping.parsing_re=(?P<date>... \d\d \d\d:\d\d:\d\d) (?P<host>.+) (?P<exe>.+?)\[(?P<pid>\d+)\]: (?P<msg>.*)" client_options.sensor_seed_key=testclient1 "client_options.mapping.mapping[0].src_field=host" "client_options.mapping.mapping[0].dst_field=syslog_hostname"
```

Pipe the syslog from a Debian box to the container.
```
journalctl -f -q | netcat 127.0.0.1 4444
```

### S3

```
./general s3 client_options.identity.installation_key=e9a3bcdf-efa2-47ae-b6df-579a02f3a54d client_options.identity.oid=8cbe27f4-bfa1-4afb-ba19-138cd51389cd client_options.platform=carbon_black client_options.sensor_seed_key=tests3 bucket_name=lc-cb-test access_key=YYYYYYYYYY secret_key=XXXXXXXX  "prefix=events/org_key=NKZFDWEM/"
```

### Stdin

```
./adapter stdin client_options.identity.installation_key=e9a3bcdf-efa2-47ae-b6df-579a02f3a54d client_options.identity.oid=8cbe27f4-bfa1-4afb-ba19-138cd51389cd client_options.platform=text "client_options.mapping.parsing_re=(?P<date>... \d\d \d\d:\d\d:\d\d) (?P<host>.+) (?P<exe>.+?)\[(?P<pid>\d+)\]: (?P<msg>.*)" client_options.sensor_seed_key=testclient3 client_options.mapping.event_type_path=exe
```