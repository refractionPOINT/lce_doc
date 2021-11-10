# LimaCharlie Adapter

The LimaCharlie Adapter can be used to ingest external data streams from many different technologies including:

* Syslog
* AWS S3
* Google Cloud Pubsub
* STDIN

## Availability

* Docker: https://hub.docker.com/r/refractionpoint/lc-adapter
* Various Executables:
  * [Windows x64](https://app.limacharlie.io/get/adapter/win64)
  * [macOS x64](https://app.limacharlie.io/get/adapter/mac64)
  * [macOS arm64](https://app.limacharlie.io/get/adapter/macarm64)
  * [Linux x64](https://app.limacharlie.io/get/adapter/linux64)
  * [Let us know if you need a specific platform.](https://www.limacharlie.io/contact)

## Concept
The LimaCharlie Adapter is a piece of software that forwards any logs or telemetry of your choice to LimaCharlie in real-time.
It can be run on any platform and in any location (on premises for example).

The Adapter may itself get the logs/telemetry any number of locations and using many different methods like:

* Syslog
* AWS S3
* Google Cloud Pub/Sub
* STDIN

The data ingested can then parsed/mapped into JSON in the cloud by LimaCharlie according to the parameters you provided.

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

### Core Configuration

All Adapter Types support the same `client_options`, plus type-specific configurations. You should always specify the following configurations:

* `client_options.identity.oid`: the LimaCharlie Organization ID (OID) this adapter is used with.
* `client_options.identity.installation_key`: the LimaCharlie Installation Key this adapter should use to identify with LimaCharlie.
* `client_options.platform`: the type of data ingested through this adapter, like `text`, `json`, `gcp` or `carbon_black`.
* `client_options.sensor_seed_key`: an arbitrary name for this adapter which Sensor IDs (SID) are generated from, see below.

### Parsing and Mapping

#### Transformation Order
Data sent via USP can be formatted in many different ways. Data is processed in a specific order as a pipeline:
1. Regular Expression with named capture groups parsing a string into a JSON object.
1. Built-in (in the cloud) LimaCharlie parsers that apply to specific `Platform` values (like `carbon_black`).
1. The various "extractors" defined, like `EventTypePath`, `EventTimePath`, `SensorHostnamePath` and `SensorKeyPath`.
1. Custom `Mappings` directives provided by the client.

#### Configurations
The relevant configurations for this section are:

* `client_options.mapping.parsing_re`: regular expression with [named capture groups](https://github.com/StefanSchroeder/Golang-Regex-Tutorial/blob/master/01-chapter2.markdown#named-matches). The name of each group will be used as the key in the converted JSON parsing.
* `client_options.mapping.sensor_key_path`: indicates which component of the events represent unique sensor identifiers.
* `client_options.mapping.sensor_hostname_path`: indicates which component of the event represents the hostname of the resulting Sensor in LimaCharlie.
* `client_options.mapping.event_type_path`: indicates which component of the event represents the Event Type of the resulting event in LimaCharlie.
* `client_options.mapping.event_time_path`: indicates which component of the event represents the Event Time of the resulting event in LimaCharlie.
* `client_options.mapping.rename_only`: if true, indicates the field mappings defined here should only be renamed fields from the original event (and not completely replacing the original event).
* `client_options.mapping.mappings`: a list of field remapping to be performed:
  * `src_field`: the source component to remap.
  * `dst_field`: what the SourceField should be mapped to in the final event.

#### Parsing

If the data ingested in LimaCharlie is text (a syslog line for example), you may automatically parse it into a JSON format.
To do this, you need to define the `client_options.mapping.parsing_re` option. It should contain a regular expression with [named capture groups](https://github.com/StefanSchroeder/Golang-Regex-Tutorial/blob/master/01-chapter2.markdown#named-matches).

For example, if an ingested log line is:
```
Nov 09 10:57:09 penguin PackageKit[21212]: daemon quit
```

you could apply the following regular expression as `parsing_re`:
```
(?P<date>... \d\d \d\d:\d\d:\d\d) (?P<host>.+) (?P<exe>.+?)\[(?P<pid>\d+)\]: (?P<msg>.*)
```

which would result in the following event in LimaCharlie:
```json
{
  "date": "Nov 09 10:57:09",
  "host": "penguin",
  "exe": "PackageKit",
  "pid": "21212",
  "msg": "daemon quit"
}
```

#### Mapping

Mapping takes the JSON generated or parsed, and moves/renames some of its fields.

All mapping records (a record defines a single field transformation) are located in the `client_options.mapping.mappings` option.

A record has two components: a `src_field` which describes the field to transform, and a `dst_field` which is the destination field.

If the `rename_only` option is `false` (or absent), the final event will contain _only_ the fields that were specified in the mapping.
This means the mapping can be used to reduce the size of events or remove entire fields. If the `rename_only` option is `true`, then
the renamed fields will be set _on top of_ the original event content.

For example, taking the example from above:
```json
{
  "date": "Nov 09 10:57:09",
  "host": "penguin",
  "exe": "PackageKit",
  "pid": "21212",
  "msg": "daemon quit"
}
```

and applying the following mapping configuration:
```
rename_only: true

src_field: exe
dst_field: process_name
```

would result in the following event:

```json
{
  "date": "Nov 09 10:57:09",
  "host": "penguin",
  "process_name": "PackageKit",
  "pid": "21212",
  "msg": "daemon quit"
}
```

while applying this mapping:
```
rename_only: false

src_field: exe
dst_field: process_name

src_field: date
dst_field: timestamp
```

would result in:

```json
{
  "timestamp": "Nov 09 10:57:09",
  "process_name": "PackageKit"
}
```

#### Extraction

LimaCharlie has a few core constructs that all events and sensors have.
Namely:

* Sensor ID
* Hostname
* Event Type
* Event Time

You may specify certain fields from the JSON logs to be extracted into these common fields.

This process is done by specifying the "path" to the relevant field in the JSON data. Paths are like a directory path using `/` for each sub-directory
except that in our case, they describe how to get to the relevant field from the top level of the JSON.

For example, using this event:
```json
{
  "a": "x",
  "b": "y",
  "c": {
    "d": {
      "e": "z"
    }
  }
}
```

The following paths would yield the following results:

* `a`: `x`
* `b`: `y`
* `c/d/e`: `z`

The following extractors can be specified:
* `client_options.mapping.sensor_key_path`: indicates which component of the events represent unique sensor identifiers.
* `client_options.mapping.sensor_hostname_path`: indicates which component of the event represents the hostname of the resulting Sensor in LimaCharlie.
* `client_options.mapping.event_type_path`: indicates which component of the event represents the Event Type of the resulting event in LimaCharlie.
* `client_options.mapping.event_time_path`: indicates which component of the event represents the Event Time of the resulting event in LimaCharlie.

### Sensor IDs
USP Clients generate LimaCharlie Sensors at runtime. The ID of those sensors (SID) is generated based on the Organization ID (OID) and the Sensor Seed Key.

This implies that if want to re-key an IID (perhaps it was leaked), you may replace the IID with a new valid one. As long as you use the same OID and Sensor Seed Key, the generated SIDs will be stable despite the IID change.

## Examples

### Syslog

This example assumes you want the Adapter to run as a Syslog endpoint over TCP.
We also assume you want to run the Adapter from within a Docker container.

```
docker run --rm -it -p 4444:4444 refractionpoint/lc-adapter:latest syslog port=4444 client_options.identity.installation_key=e9a3bcdf-efa2-47ae-b6df-579a02f3a54d client_options.identity.oid=8cbe27f4-bfa1-4afb-ba19-138cd51389cd client_options.platform=text "client_options.mapping.parsing_re=(?P<date>... \d\d \d\d:\d\d:\d\d) (?P<host>.+) (?P<exe>.+?)\[(?P<pid>\d+)\]: (?P<msg>.*)" client_options.sensor_seed_key=testclient1 client_options.mapping.rename_only=true "client_options.mapping.mapping[0].src_field=host" "client_options.mapping.mapping[0].dst_field=syslog_hostname"
```

Here's a breakdown of the above example:

* `docker run --rm`: run a container and don't keep the contents around when it's stopped.
* `-it`: make the container interactive so you can ctrl-c to stop it.
* `-p 4444:4444`: allow the container to listen on port `4444` on the local host and use the same port within the container.
* `refractionpoint/lc-adapter:latest`: this is the name of the public container provided by LimaCharlie.
* `syslog`: the method the Adapter should use to collect data locally. The `syslog` value will operate as a syslog endpoint on the TCP port specified.
* `port=4444`: the TCP port the Adapter should listen on. By default this is a normal TCP connection (not SSL), although SSL options exist.
* `client_options.identity.installation_key=....`: the installation key value from LimaCharlie.
* `client_options.identity.oid=....`: the Organization ID from LimaCharlie the installation key above belongs to.
* `client_options.platform=text`: this indicates the type of data that will be received from this adapter. In this case it's syslog, so `text` lines.
* `client_options.mapping.parsing_re=....`: this is the parsing expression describing how to interpret the text lines and how to convert them to JSON.
* `client_options.sensor_seed_key=....`: this is the value that identifies this instance of the Adapter. Record it to re-use the Sensor ID generated for this Adapter later if you have to re-install the Adapter.
* `client_options.mapping.rename_only=true`: only rename the field in mapping below, so keep the other original fields.
* `client_options.mapping.mapping[0].src_field=....`: the source field of the first mapping record.
* `client_options.mapping.mapping[0].dst_field=....`: the destination field of the first mapping record.

To test it, assuming we're on the same Debian box as the container, pipe the syslog to the container:
```
journalctl -f -q | netcat 127.0.0.1 4444
```

### CarbonBlack from S3

This example shows connecting Carbon Black sensors from data exported by the Carbon Black API to an S3 bucket.
It uses the CLI Adapter (instead of the Docker container).

```
./lc_adapter s3 client_options.identity.installation_key=e9a3bcdf-efa2-47ae-b6df-579a02f3a54d client_options.identity.oid=8cbe27f4-bfa1-4afb-ba19-138cd51389cd client_options.platform=carbon_black client_options.sensor_seed_key=tests3 bucket_name=lc-cb-test access_key=YYYYYYYYYY secret_key=XXXXXXXX  "prefix=events/org_key=NKZAAAEM/"
```

Here's a breakdwn of the above example:

* `lc_adapter`: simply the CLI Adapter.
* `s3`: the data will be collected from an AWS S3 bucket.
* `client_options.identity.installation_key=....`: the installation key value from LimaCharlie.
* `client_options.identity.oid=....`: the Organization ID from LimaCharlie the installation key above belongs to.
* `client_options.platform=carbon_black`: this indicates the data received will be CarbonBlack events from their API.
* `client_options.sensor_seed_key=....`: this is the value that identifies this instance of the Adapter. Record it to re-use the Sensor IDs generated for the CarbonBlack sensors from this Adapter later if you have to re-install the Adapter.
* `bucket_name:....`: the name of the S3 bucket holding the data.
* `secret_key:....`: the API key for AWS that has access to this bucket.
* `prefix=....`: the file/directory name prefix that holds the CarbonBlack data within the bucket.

### Stdin

This example is similar to the Syslog example above, except it uses the CLI Adapter and receives the data from the CLI's STDIN interface.
This method is perfect for ingesting arbitrary logs on disk or from other applications locally.

```
./lc_adapter stdin client_options.identity.installation_key=e9a3bcdf-efa2-47ae-b6df-579a02f3a54d client_options.identity.oid=8cbe27f4-bfa1-4afb-ba19-138cd51389cd client_options.platform=text "client_options.mapping.parsing_re=(?P<date>... \d\d \d\d:\d\d:\d\d) (?P<host>.+) (?P<exe>.+?)\[(?P<pid>\d+)\]: (?P<msg>.*)" client_options.sensor_seed_key=testclient3 client_options.mapping.event_type_path=exe
```

Here's a breakdwn of the above example:

* `lc_adapter`: simply the CLI Adapter.
* `stdin`: the method the Adapter should use to collect data locally. The `stdin` value will simply ingest from the Adapter's STDIN.
* `client_options.identity.installation_key=....`: the installation key value from LimaCharlie.
* `client_options.identity.oid=....`: the Organization ID from LimaCharlie the installation key above belongs to.
* `client_options.platform=text`: this indicates the type of data that will be received from this adapter. In this case it's `text` lines.
* `client_options.mapping.parsing_re=....`: this is the parsing expression describing how to interpret the text lines and how to convert them to JSON.
* `client_options.sensor_seed_key=....`: this is the value that identifies this instance of the Adapter. Record it to re-use the Sensor ID generated for this Adapter later if you have to re-install the Adapter.
* `client_options.mapping.event_type_path=....`: specifies the field that should be interpreted as the "event_type" in LimaCharlie.

### Stdin JSON

This example is similar to the Stdin example above, except it assumes the data being read is JSON, not just text.
If your data source is already JSON, it's much simpler to let LimaCharlie do the JSON parsing directly.

```
./lc_adapter stdin client_options.identity.installation_key=e9a3bcdf-efa2-47ae-b6df-579a02f3a54d client_options.identity.oid=8cbe27f4-bfa1-4afb-ba19-138cd51389cd client_options.platform=json client_options.sensor_seed_key=testclient3 client_options.mapping.event_type_path=type
```

Here's a breakdwn of the above example:

* `lc_adapter`: simply the CLI Adapter.
* `stdin`: the method the Adapter should use to collect data locally. The `stdin` value will simply ingest from the Adapter's STDIN.
* `client_options.identity.installation_key=....`: the installation key value from LimaCharlie.
* `client_options.identity.oid=....`: the Organization ID from LimaCharlie the installation key above belongs to.
* `client_options.platform=json`: this indicates that the data read is already JSON, so just parse it as so.
* `client_options.sensor_seed_key=....`: this is the value that identifies this instance of the Adapter. Record it to re-use the Sensor ID generated for this Adapter later if you have to re-install the Adapter.
* `client_options.mapping.event_type_path=....`: specifies the field that should be interpreted as the "event_type" in LimaCharlie.

Note that we did not need to specify a `parsing_re` because the data ingested is not text, but already JSON, so the Parsing step is already done for us by setting a `platform=json`.