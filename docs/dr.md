# Detection and Response Rules

Detection & Response rules are designed to allow you to push out a detection rule and with a custom action in record time.
Think of them like AWS Lambda or Google Cloud Functions. They can be added and removed with single operations
and they become immediately available/running as they are set.

A D&R rule has two components:

* the detection part of the rule is a simple expression that describes what the rule should match on.
* the response part of the rule describes the list of actions that should be taken when the rule matches.

The REST interface expects those rules in their native JSON format (as described below), but UIs to generate this
format are available if you are uncomfortable with the JSON.

For more sample rules and guidelines around rule writing, see our [public repository dedicated to this purpose](https://github.com/refractionPOINT/rules).

The website version of this (on limacharlie.io) takes the rules as YAML to make them easier to visualize.

## Namespaces
Detection and Response rules support a few namespaces. Initially you do not have to worry about using them since by default
operations on rules use the `general` namespace.

However, if you plan on having multiple groups of people accessing DR rules and want to maintain some segmentation, then
namespaces are for you. An example of this is an MSSP wanting to allow their customers to create their own rules without
giving them access to the MSSP-maintained sets of rules.

Beyond the `general` namespace, the main other namespace is called `managed` (as in MSSP-managed). Currently, operating
on namespaces other than `general` can only be accomplished using the [REST API](api_keys.md) by providing the `namespace`
parameter in the relevant queries.

## Expiration
It is possible to set an experation time for D&R rules as well as False Positive rules. The expiration is set by providing
a `expire_on` paramater when creating/setting the D&R or FP rule. The value of the parameter should be a second-based
unix epoch timestamp, like `expire_on: 1588876878`.

Once that timestamp has been reached, the rule will be automatically deleted. Note that the exact precision of the expiration
can vary, the rule could effectively remain in operation for as long as 10 minutes past the expiration.

## Detection Component
The Detection component describes what event(s) should produce a match, which the Response section will then action.

### Targets

Targets are types of sources of events that the rule should apply to. The D&R rules apply by default to the `edr` target.
This means that if you omit the `target` element from the Detection component, the rule will assume you want it to apply
to events coming from the LimaCharlie agents. Other targets are available however.

* `edr`: the default, [telemetry events](events.md#edr-events) from LC agents.
* `artifact`: applies to artifacts submitted through the REST API or through the [artifact_get](sensor_commands.md#artifact_get) command of the agent.
* `artifact_event`: applies to lifecycle around artifacts, like a new artifact being ingested.
* `deployment`: applies to [high level events](events.md#deployment-events) about the entire deployment, like new enrollments and cloned sensors detected.

While the `edr` and `deployment` targets supports most of the APIs, stateful operators and actions below, the `log` target only supports the following subset:

* All the basics: `is`, `and`, `or`, `exists`, `contains`, `starts with`, `ends with`, `is greater than`, `is lower than`, `matches`, `string distance`
* Referring to add-ons / resources: `lookup`, `external`
* Response actions: `report`
* `artifact` target only: `artifact source`, `artifact type`

In the case of the `log` target, `path` references apply to JSON parsed logs the same way as in `edr` DR rules, but rules on pure text logs requires using the
path `/text` as the value of a log line. The `artifact source` matches the log's source string, and the `artifact type` matches the log's type string.  You may use the top-level filter `artifact path` which acts as a Prefix to the original Artifact path.

For examples of D&R rules applying to artifacts, you can look at the [Sigma rules generated for the Sigma Service](https://github.com/refractionPOINT/sigma/tree/lc-rules/lc-rules/windows_builtin) which uses the Windows Event Logs.

#### Windows Event Logs
When running D&R rules against Windows Event Logs (`target: artifact` and `artifact type: wel`), although the [Artifact Collection Service](external_logs.md) may ingest
the same Windows Event Log file that contains some records that have already been processed by the rules, the LimaCharlie platform will keep track of the
processed `EventRecordID` and therefore will NOT run the same D&R rule over the same record multiple times.

This means you can safely set the [Artifact Collection Service](external_logs.md) to collect various Windows Event Logs from your hosts and run D&R rules over them
without risking producing the same alert multiple times.

For most Windows Event Logs available, see `c:\windows\system32\winevt\logs\`.

### Basic Structure

Each logical operation in this component is a dictionary with an `op` field. Complex logical evaluation is done
by using two special `op` values, `and` and `or`. These will take a `rules` parameter that is a list of other logical
operations to perform.

Here is a basic example of a rule that says:
When we receive a `STARTING_UP` event from a linux sensor, and this sensor has the tag `test_tag`, match.

```json
{
    "op": "and",
    "rules" : [
        {
            "op": "is linux",
            "event": "STARTING_UP"
        },
        {
            "op" : "is tagged",
            "tag": "test_tag"
        }
    ]
}
```

The `"event": "SOME_EVENT_NAME"` pattern can be used in all logical nodes to filter the type of event being
evaluated. You can also use an `"events": [ "EVENT_ONE", "EVENT_THREE"]` to filter in certain types of events. When a detection is generated (through the `report` action), it gets fed back into D&R rules with an `event_type`
of `_DETECTIONNAME`. This can be used to compose higher order detections. Finally, a special value can be used in the
`event`/`events` field: `_*`. By specifying this `_*` wildcard as the only value of `event:`, you ask the D&R rule engine
to match against all Detections that are re-sent through the engine as describe previously. This effectively allows you to relax the rule of having at least one `event:` type literal in your rule for Detections. Example: `event: _*` will match all detections.

### Logical Operations
Some parameters are available to all logical operations.

* `"not": true`: will reverse the matching outcome of an operations.
* `"case sensitive": false`: will make all string-based evaluations ignore case.

#### Paths

A recurring parameter also found in many operations is the `"path": <>` parameter. It represents a path within the event
being evaluated that we want the value of. Its structure is very close to a directory structure. It also supports the
`*` wildcard to represent 0 or more directories, and the `?` wildcard which represents exactly one directory.

The root of the path should be `event` or `routing` depending on whether you want to get a value from the event itself or
the routing instead.

#### Lookback

Note that many comparison values support a special "lookback" format. That is, an operation that supports comparing
a value to a literal like `"system32"`, can also support a value of `"<<event/PARENT/FILE_PATH>>"`. When that value is
surrounded by `"<<  >>"`, it will be interpreted as a path within the event and the
value at that path will replace the `"<<...>>"` value. This allows you to "look back" at the event and use values
within for your rule.

For example, this sample JSON event:
```json
{
    "USER_ID": 501,
    "PARENT": {
        "USER_ID": 501,
        "COMMAND_LINE": "/Applications/Sublime Text.app/Contents/MacOS/plugin_host 71954",
        "PROCESS_ID": 71955,
        "USER_NAME": "maxime",
        "FILE_PATH": "/Applications/Sublime Text.app/Contents/MacOS/plugin_host",
        "PARENT_PROCESS_ID": 71954,
        "DEEP_HASH": {
            "HASH_VALUE": "ufs8f8hfinsfd9sfdsf"
        }
    },
    "PROCESS_ID": 23819,
    "FILE_PATH": "/Applications/Xcode.app/Contents/Developer/usr/bin/git",
    "PARENT_PROCESS_ID": 71955
}
```

The following paths with their result element:

* `<<event/USER_ID>>` results in `501`
* `<<event/?/USER_NAME>>` results in `"maxime"`
* `<<event/PARENT/PROCESS_ID>>` results in `71955`
* `<<event/*/HASH_VALUE>>` results in `ufs8f8hfinsfd9sfdsf`

#### Variables

It is possible to store some pieces of state on a per-sensor basis for the lifetime of a sensor (single boot).
This state is called "variables". Variables have a name and a set of values associated with them. Values can
be associated with a variable name at run-time using the `add var` (and `del var`) response.

The `add var` action supports an optional `ttl` value which is the number of seconds the value should be
set for, like `ttl: 3600`.

Other rules may then use the values in a variable as part of the detection component.

Like the "lookback" feature, variables can be used in the `is`, `contains`, `starts with` and `ends with` operators
by surrounding the variable name with `[[` and `]]`, like `[[my-var]]`.

For example, these rules looking for unsigned execution from external drives (like USB).

First, add new external drives to a variable when they are connected:

```yaml
detect:
  event: VOLUME_MOUNT
  op: is windows

respond:
  - action: add var
    name: external-volumes
    value: <<event/VOLUME_PATH>>
```

Second, look for unsigned execution starting on those drives:

```yaml
detect:
  event: NEW_PROCESS
  op: and
  rules:
    - path: event/FILE_IS_SIGNED
      value: 0
      op: is
    - path: event/FILE_PATH
      case sensitive: false
      value: '[[external-volumes]]'
      op: starts with

respond:
  - action: report
    name: unsigned-exec-removable-drive
```

#### Times

All evaluators support an optional key named `times`. When specified, it must contain a list of [Time Descriptors](lc-net.md#time-descriptor) where the given evaluator is valid. These Time Descriptors are at the "operator" level, meaning that your rule can mix-and-match multiple Time Descriptors as part of a single rule.

Example that matches the Chrome process starting between 11PM and 5AM, Monday through Friday, Pacific Time:
```yaml
event: NEW_PROCESS
op: ends with
path: event/FILE_PATH
value: chrome.exe
case sensitive: false
times:
  - day_of_week_start: 2
    day_of_week_end: 6
    time_of_day_start: 2200
    time_of_day_end: 2359
    tz: America/Los_Angeles
  - day_of_week_start: 2
    day_of_week_end: 6
    time_of_day_start: 0
    time_of_day_end: 500
    tz: America/Los_Angeles
```

#### Operators

##### and, or
The standard logical boolean operations to combine other logical operations.
Takes a single `rules:` parameter that contains a list of other operators
to "AND" or "OR" together.

Example:
```yaml
op: or
rules:
  - ...rule1...
  - ...rule2...
  - ...
```

##### is
Tests for equality between the value of the `"value": <>` parameter and the value found in the event at the `"path": <>`
parameter.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

Example rule:
```json
{
    "op": "is",
    "path": "event/PARENT/PROCESS_ID",
    "value": 9999
}
```

##### exists
Tests if any elements exist at the given path.

Example rule:
```yaml
op: exists
path: event/PARENT
```

##### contains, ends with, starts with
The `contains` checks for a substring match, `starts with` checks for a prefix match and `ends with` checks for a suffix
match.

They all use the `path` and `value` parameters.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

##### is greater than, is lower than
Check to see if a value is greater or lower (numerically) than a value in the event.

They both use the `path` and `value` parameters.
They also both support the `length of` parameter as a boolean (true or false). If set to true, instead of comparing
the value at the specified path, it compares the length of the value at that path.

##### matches
The `matches` op compares the value at `path` with a regular expression supplied in the `re` parameter.
Under the hood, this uses the Golang's `regexp` [package](https://golang.org/pkg/regexp/), which also enables 
you to apply the regexp to log files.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

Example:
```json
{
    "op": "matches",
    "path": "event/FILE_PATH",
    "re": ".*\\\\system32\\\\.*\\.scr",
    "case sensitive": false
}
```

##### string distance
The `string distance` op looks up the [Levenshtein Distance](https://en.wikipedia.org/wiki/Levenshtein_distance) between
two strings. In other words it generates the minimum number of character changes required for one string
to become equal to another.

For example, the Levenshtein Distance between `google.com` and `googlr.com` (`r` instead of `e`) is 1.

This can be used to find variations of file names or domain names that could be used for phishing, for example.

Suppose your company is `onephoton.com`, looking for the Levenshtein Distance between all `DOMAIN_NAME` in
`DNS_REQUEST` events, compared to `onephoton.com` could detect an attacker using `onephot0n.com` in a phishing
email domain.

The operator takes a `path` parameter indicating which field to compare, a `max` parameter indicating the
maximum Levenshtein Distance to match and a `value` parameter that is either a string or a list of strings
that represent the value(s) to compare to. Note that although `string distance` supports the `value` to be
a list, most other operators do not.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

Example:
```yaml
op: string distance
path: event/DOMAIN_NAME
value:
  - onephoton.com
  - www.onephoton.com
max: 2
```
This would match `onephotom.com` and `0nephotom.com` but NOT `0neph0tom.com`.

and using the [file name](#file-name) transform to apply to a file name in a path:
```yaml
op: string distance
path: event/NEW_PROCESS
file name: true
value:
  - svchost.exe
  - csrss.exe
max: 2
```

This would match `svhost.exe` and `csrss32.exe` but NOT `csrsswin32.exe`.

##### is windows, is linux, is mac, is chrome, is 32 bit, is 64 bit
All of these operators take no additional arguments, they simply match if the relevant sensor characteristic is
correct.

##### is tagged
Determines if the tag supplied in the `tag` parameter is already associated with the sensor that the event under evaluation
is from.

##### lookup
Looks up a value against a LimaCharlie Resource such as a threat feed. The value is supplied via the `path` parameter and
the resource path is defined in the `resource` parameter. Resources are of the form `lcr://<resource_type>/<resource_name>`.
In order to access a resource you must have subscribed to it via `app.limacharlie.io`.

Supports the [file name](#file-name) and [sub domain](#sub-domain) transforms.

Example:
```json
{
    "op": "lookup",
    "path": "event/DOMAIN_NAME",
    "resource": "lcr://lookup/malwaredomains",
    "case sensitive": false
}
```

##### scope
In some cases, you may want to limit the scope of the matching and the `path` you use
to be within a specific part of the event. The `scope` operator allows you to do just
that, reset the root of the `event/` in paths to be a sub-path of the event.

This comes in as very useful for example when you want to test multiple values of a
connection in a `NETWORK_CONNECTIONS` event but always on a per-connection. If you
were to do a rule like:

```yaml
event: NETWORK_CONNECTIONS
op: and
rules:
  - op: starts with
    path: event/NETWORK_ACTIVITY/?/SOURCE/IP_ADDRESS
    value: '10.'
  - op: is
    path: event/NETWORK_ACTIVITY/?/DESTINATION/PORT
    value: 445
```

you would hit on events where _any_ connection has a source IP prefix of `10.` and
_any_ connection has a destination port of `445`. Obviously this is not what we had
in mind, we wanted if a _single_ connection has those two characteristics.

The solution is to use the `scope` operator. The `path` in the operator will become
the new `event/` root path in all operators found under the `rule`. So the above
would become

Example:
```yaml
event: NETWORK_CONNECTIONS
op: scope
path: event/NETWORK_ACTIVITY/
rule:
  op: and
  rules:
    - op: starts with
      path: event/SOURCE/IP_ADDRESS
      value: '10.'
    - op: is
      path: event/DESTINATION/PORT
      value: 445
```

##### Stateful

###### Process Level

Generally the D&R rules operate in a stateless fashion, meaning a rule operates on one event at a time and either matches or doesn't.

To be able to perform D&R rules across events to detect more complex behaviors, you can use the `with child` and `with descendant`
parameters. Note that those parameters can ONLY be specified on a rule operator specifying the `event: NEW_PROCESS` since they only
apply to the relationship between an event and a process.

Both the `with child` and `with descendant` parameters are effectively the same except for the "depth" of the relationship they cover.
The `child` specifies that the target state (described below) must apply to the direct children of the matching process. The `descendant`
specifies that the target state must apply globally to any descendands (children of children) of the matching process.

The value of a `with child` (or descendant) is simply another (stateless) rule operator. The logic defined in this rule operator describes
the set of conditions that must match, not a single event, but the collection of events that are children (or descendants) of the matching
process.

Here is an example of a stateful detection looking for a "cmd.exe" process that has a child "calc.exe":

```yaml
op: ends with
event: NEW_PROCESS
path: event/FILE_PATH
value: cmd.exe
case sensitive: false
with child:
  op: ends with
  event: NEW_PROCESS
  path: event/FILE_PATH
  value: calc.exe
  case sensitive: false
```

Simply put, this will detect

```
cmd.exe --> calc.exe
```

but not

```
cmd.exe --> firefox.exe --> calc.exe
```

If we made the `with child` a `with descendant`, then we could detect:

```
cmd.exe --> firefox.exe --> powershell.exe --> calc.exe
```

Much like other stateless rules, the `with child` (and descendant) can also be more complex. For example:

```yaml
op: ends with
event: NEW_PROCESS
path: event/FILE_PATH
value: outlook.exe
case sensitive: false
with child:
  op: and
  rules:
    - op: ends with
      event: NEW_PROCESS
      path: event/FILE_PATH
      value: chrome.exe
      case sensitive: false
    - op: ends with
      event: NEW_DOCUMENT
      path: event/FILE_PATH
      value: .ps1
      case sensitive: false
```

The above example is looking for an `outlook.exe` process that spawns a `chrome.exe` and drops a `.ps1` (powershell) file to disk:

```
outlook.exe --+--> chrome.exe
              |
              +--> New .ps1 file
```

On top of containing stateless rules, an operator underneath a `with child` (or descendant) can also contain another operator with another `with child` (or descendant).

Another parameter comes into play if you want to define a set of operators underneath a `with child` to be "stateless", meaning where you want all the operators to apply
and match with single events (like the classic stateless D&R rules). This parameter is `is stateless: true`. Simply add it to the operators at the root of the logic you
want to be applied statelessly.

Finally, a node in stateful mode under a `with child` or `with descendant` can specify a `count: N` parameter. When specified, you specify that the given node must be
matched N times before it is considered successful. So setting `count: 3` in a node looking for a `event/FILE_PATH` ending in `cmd.exe` will mean that we want to match
only if we see 3 instances of a `cmd.exe` in that context to match. An example usage of this is to set `count:` in a `matches` operator looking for a set of processes
which would result in detecting a "burst" of matching processes from a parent (like: if a process starts more than 3 `cmd.exe`, alert). Adding a `within: Z` parameter
to the `count: N` limits the count to where the first and last event in the count is within a `Z` seconds time window.


Example rule that matches on Outlook writing 5 new `.ps1` documents within 60 seconds.

```yaml
op: ends with
event: NEW_PROCESS
path: event/FILE_PATH
value: outlook.exe
case sensitive: false
with child:
    op: ends with
    event: NEW_DOCUMENT
    path: event/FILE_PATH
    value: .ps1
    case sensitive: false
    count: 5
    within: 60
```

###### Sensor Level

You may want to correlate activity, not in the context of process relationship, but at the sensor level instead.
For example, you may want to detect "if 5 bad login attempts occur on a Windows box within 60 seconds". Since you may
be relying on the `WEL` events (Windows Event Logs), it doesn't make sense to use `with child` or `with descendant`.

For these cases, you can use the `with events` parameter, like this:

```yaml
event: WEL
op: is windows
with events:
  event: WEL
  op: is
  path: event/EVENT/System/EventID
  value: '4625'
  count: 5
  within: 60

```

Much like `with child`, the `with events` defines that the rule underneath it should be evaluated in "stateful mode", and
in a single "global" context for each sensor. This means the rule underneath could also be a complex evaluation using `op: and`
containing the evaluation of several different event types which must all be true for the rule to match.

###### Testing

When testing stateful D&R rules, it is important to keep in mind that the state engine is forward-looking only and that
changing a stateful rule will reset its state tracking.

Concretely this means that if your rule is tracking, for example, `excel.exe --child of--> cmd.exe` and you modify your
rule, even just a little, you will need to make sure to re-launch the `excel.exe` instance you're doing your testing
with since the engine will no longer be aware of its previous launch.

###### Reporting & Actions

The `report` action in stateful rules has a subtle difference to other actions taken in those rules. The report
(generating a new Detection) will include the _first_ telemetry event that started the stateful detection as the
`detect` component of the detection.

For example, with `excel.exe --child of--> cmd.exe`, the detection will include the `excel.exe` as the `detect`.

For other actions (responses in the rule) however, the event under analysis is the last one being processed. So
if the engine is analyzing the `cmd.exe` NEW_PROCESS, issuing a `report` will report the `excel.exe` in the detection
but doing issuing a `task` that uses the lookback `<<routing/this>>` will reference the `this` atom of the `cmd.exe`.

So if you wanted to kill the `excel.exe` in response to the above stateful rule matching, you would have to issue a
`deny_tree` to the atom `<<routing/parent>>`.

##### VirusTotal
The lookup can also use certain APIs in their lookup, such as VirusTotal. Note that for the VT API to be accessible, the
organization needs to be subscribed to the VT API Add-On, and a valid VT API Key needs to be set in the integrations
configurations.

As shown in the example below, a `metadata_rules` parameter is also valid for the lookup operation. It can contain
further detection rules to be applied to ***the metadata returned by a lookup match***. In the case of VT this is a dictionary
of AntiVirus vendor reports (here we test for more than 1 vendor reporting that the hash is bad), while in the case of a custom
lookup resource it would be whatever is set as the item's metadata.

To activate VirusTotal usage, you must subscibe to the VirusTotal API in the Add-On section. Then you must set your VirusTotal
API key in the Integrations section of the limacharlie.io web interface.

VirusTotal results are cached locally for a limited period of time which reduces the usage of your API key and saves you money.

Also note that if your API Key runs out of quota with VirusTotal, hashes seen until you have quota again will be ignored.

Example:
```yaml
op: lookup
event: CODE_IDENTITY
path: event/HASH
resource: 'lcr://api/vt'
metadata_rules:
  op: is greater than
  value: 1
  path: /
  length of: true
```

##### IP GeoLocation
The lookup can also use certain APIs in their lookup, like IP GeoLocation. Note that for the IP GeoLocation to be accessible, the
organization needs to be subscribed to the `api/ip-geo` API Add-On.

As shown in the example below, a `metadata_rules` parameter is also valid for the lookup operation. It can contain
further detection rules to be applied to ***the metadata returned by a lookup match***. In the case of `ip-geo` this is a dictionary
of the geolocation data returned by the IP GeoLocation data provider, [MaxMind.com](https://maxmind.com).

The format of the metadata returned is documented [here](https://github.com/maxmind/MaxMind-DB-Reader-python) and looks like this:

```json
{
  "country": {
    "geoname_id": 2750405,
    "iso_code": "NL",
    "is_in_european_union": true,
    "names": {
      "ru": "\u041d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u044b",
      "fr": "Pays-Bas",
      "en": "Netherlands",
      "de": "Niederlande",
      "zh-CN": "\u8377\u5170",
      "pt-BR": "Holanda",
      "ja": "\u30aa\u30e9\u30f3\u30c0\u738b\u56fd",
      "es": "Holanda"
    }
  },
  "location": {
    "latitude": 52.3824,
    "accuracy_radius": 100,
    "time_zone": "Europe/Amsterdam",
    "longitude": 4.8995
  },
  "continent": {
    "geoname_id": 6255148,
    "code": "EU",
    "names": {
      "ru": "\u0415\u0432\u0440\u043e\u043f\u0430",
      "fr": "Europe",
      "en": "Europe",
      "de": "Europa",
      "zh-CN": "\u6b27\u6d32",
      "pt-BR": "Europa",
      "ja": "\u30e8\u30fc\u30ed\u30c3\u30d1",
      "es": "Europa"
    }
  },
  "registered_country": {
    "geoname_id": 2750405,
    "iso_code": "NL",
    "is_in_european_union": true,
    "names": {
      "ru": "\u041d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u044b",
      "fr": "Pays-Bas",
      "en": "Netherlands",
      "de": "Niederlande",
      "zh-CN": "\u8377\u5170",
      "pt-BR": "Holanda",
      "ja": "\u30aa\u30e9\u30f3\u30c0\u738b\u56fd",
      "es": "Holanda"
    }
  }
}
```

To activate IP GeoLocation usage, you must subscibe to the `api/ip-geo` API in the Add-On section.

Also note that if your API Key runs out of quota with VirusTotal, hashes seen until you have quota again will be ignored.

Example (is the connecting agent in a European Union country):
```yaml
op: lookup
resource: 'lcr://api/ip-geo'
path: routing/ext_ip
event: CONNECTED
metadata_rules:
  op: is
  value: true
  path: country/is_in_european_union
```

The geolocation data comes from GeoLite2 data created by [MaxMind](http://www.maxmind.com).

##### external
Use an external detection rule loaded from a LimaCharlie Resource. The resource is specified via the `resource` parameter.
Resources are of the form `lcr://<resource_type>/<resource_name>`. The `external` operation only supports Resources of
type `detection`. The external detection replaces the current detection rule, which means it can be combined with other
detection logic using the `and` and `or` operations.

Example:
```json
{
    "op": "external",
    "resource": "lcr://detection/suspicious-windows-exec-location"
}
```

Complex example extending a resource rule:
```yaml
op: and
rules:
  - op: is tagged
    tag: finance-dept
  - op: external
    resource: lcr://detection/suspicious-windows-exec-location
```

##### yara
Only accessible for the `target: artifact`. Scans the relevant original log file in the cloud using the Yara signature specified.

The Yara signatures are specified as a LimaCharlie Resource of the form `lcr://<resource_type>/<resource_name>`. Currently
the main source of Yara signatures are the [Yara Sources](yara.md#sources) specified in the [Yara Service](yara.md). If your Yara Source is
named `my-yara-source`, the LC Resource would be: `lcr://service/yara/my-yara-source`.

The `yara` operator scan the log file at most once. This means it can be used both as a simple "scan" detection like this:

```yaml
op: yara
target: artifact
resource: lcr://service/yara/my-yara-source
```

Or it can also be used as part of a more complex D&R rule evaluation like this:

```yaml
target: artifact
artifact type: pe
op: and
rules:
  - op: yara
    resource: lcr://service/yara/my-yara-source
  - op: contains
    path: PDB
    value: RemoteShellsRemote
```

The rule above would match when an executable is a match with the Yara signature AND has a PDB containing `RemoteShellsRemote`.

### Transforms
Transforms are transformations applied to the value being evaluated in an event, prior to the evaluation.

#### file name
Sample: `file name: true`

The `file name` transform takes a file path and replaces it with the file name component of the path.
This means that the file path `c:\windows\system32\wininet.dll` will become `wininet.dll`.

#### sub domain
Sample: `sub domain: "-2:"`

The `sub domain` extracts specific components from a domain name. The value of `sub domain` is in basic slice notation.
This notation is of the form `startIndex:endIndex` where the index is 0-based and indicates which parts of the domain to keep.
Examples:

  * `0:2` means the first 2 components of the domain: `aa.bb` for `aa.bb.cc.dd`.
  * `-1` means the last component of the domain: `cc` for `aa.bb.cc`.
  * `1:` means all components starting at 1: `bb.cc` for `aa.bb.cc`.
  * `:` means to test the operator to every component individually.

## Response Component
The response component is simpler as it does not have the boolean logic concept. It is simply a list of actions to take
when the Detection component matches.

The action type is specified in the `action` parameter.

### Actions
Possible actions are:

#### task
This action sends the task (as described [here](sensor_commands.md)) in the `command` parameter to the sensor that the event
under evaluation is from. An optional `investigation` parameter can be given, it associates the given
identifier with the task and events from the sensor that relate to the task.

Example:
```json
{
    "action": "task",
    "command": "history_dump",
    "investigation": "susp-process-inv"
}
```

#### report
Reports the match as a detection. This means that the content of this event will be bubbled up to the Detection Output
stream. Think of it as an alert. It takes a `name` parameter that will be used as a detection category and an optional `publish`
parameter that defaults to `true`. If set to `false`, the report won't be published to the Output stream.

This last distinction about the `publish` parameter is important because the detections created by the `report` action
get fed back into the D&R rules so that more complex rules may handle more complex evaluations of those.
Setting `publish` to `false` means that this detection is only really used as an intermediary and should not be reported in and
of itself. When fed back, the `event_type` is set to `_DETECTIONNAME`.

A "non-published" rule stays within the D&R system only (as stated above), but sometimes we also want Services
to get a notification of the detection without having the detection recorded to Outputs
or retention. For example, a Service may want to listen for the `CONNECTED` event to do
something and it makes no sense to record this detection after Services have been notified. To
accomplish this, you can simply prefix your detection `name` with `__` (double underscore).

The `priority` parameter is optional. If set, it should be an integer. This integer
will get added to the root of the detection report.

The `metadata` parameter is optional. It can be set to any data which will be included
in the detection generated in a field named `detect_mtd` at the root of the detection.
This can be used to include information for internal use like reference numbers or URLs.

Example:
```yaml
action: report
name: my-detection
priority: 3
```

#### add tag, remove tag
These two actions associate and disassociate, respectively, the tag found in the `tag` parameter with the sensor. The "add tag" operation
can also optionally take a "ttl" parameter that is a number of seconds the tag should remain applied to the agent.

Example:
```json
{
    "action": "add tag",
    "tag": "vip",
    "ttl": 30
}
```

Optionally, you may set a `entire_device` parameter to `true` in the `add tag`. When enabled, the new tag will apply
to the entire [Device ID](agentid.md#device-ids), meaning that every sensor that shares this Device ID will have the tag applied (and relevant TTL). If the sensor where this response is triggered does not belong to a Device ID, then the sensor will be tagged.

This can be used as a main mechanism to synchronize and operate changes across an entire device. A D&R rule could detect a behavior and then tag the whole device in order to signal to other sensors to act differently, like lc-net to start doing full pcap.

For example, this would apply the `full_pcap` to all sensors on the device for 5 minutes:

```yaml
action: add tag
tag: full_pcap
ttl: 300
entire_device: true
```

#### add var, del var
Add or remove a value from the variables associated with a sensor.

Example:
```yaml
action: add var
name: my-variable
value: <<event/VOLUME_PATH>>
```

#### service request
Perform an asynchronous request to a service the organization is subscribed to. A service
request contains two main component: the `name` of the service, like `dumper`, and the arbitrary
content of the request to this service in the `request` value. The request content
will vary depending on the service (see the relevant service's documentation).

All values within the `request` can contain [Lookback](#lookback) values (`<< >>`).

Example:
```yaml
action: service request
name: dumper
request:
  sid: <<routing/sid>>
  retention: 3
```

#### isolate network
Isolates the sensor from the network in a persistent fashion (if the sensor/host reboots, it will remain isolated).
Only works on platforms supporting the `segregate_network` [sensor command](sensor_commands.md#segregate_network).

```yaml
action: isolate network
```

#### rejoin network
Removes the isolation status of a sensor that had it set using `isolate network`.

```yaml
action: rejoin network
```

#### undelete sensor
Un-deletes a sensor that was previously deleted. Used in conjunction with the [sensor_deleted](events.md#sensor_deleted) event.

```yaml
action: undelete sensor
```

## Putting it Together

Note that through limacharlie.io, in order to provide an easier to edit format, the same rule configuration
is used but is in YAML format instead. For example:
**Detect:**
```yaml
op: ends with
event: NEW_PROCESS
path: event/FILE_PATH
value: .scr
```

**Respond:**
```yaml
- action: report
  name: susp_screensaver
- action: add tag
  tag: uses_screensaver
  ttl: 80000
```

### WanaCry
Simple WanaCry detection and mitigation rule:

**Detect**
```json
{
    "op": "ends with",
    "event": "NEW_PROCESS",
    "path": "event/FILE_PATH",
    "value": "@wanadecryptor@.exe",
    "case sensitive": false
}
```

**Respond**
```json
[
    {
        "action": "report",
        "name": "wanacry"
    },
    {
        "action": "task",
        "command": "history_dump"
    },
    {
        "action": "task",
        "command": [ "deny_tree", "<<routing/this>>" ]
    }
]
```


### Classify Users
Tag any sensor where the CEO logs in with "vip".

**Detect**
```json
{
    "op": "is",
    "event": "USER_OBSERVED",
    "path": "event/USER_NAME",
    "value": "stevejobs",
    "case sensitive": false
}
```

**Respond**
```json
[
    {
        "action": "add tag",
        "tag": "vip"
    }
]
```

### Suspicious Windows Executable Names
```json
{
    "op": "matches",
    "path": "event/FILE_PATH",
    "case sensitive": false,
    "re": ".*((\\.txt)|(\\.doc.?)|(\\.ppt.?)|(\\.xls.?)|(\\.zip)|(\\.rar)|(\\.rtf)|(\\.jpg)|(\\.gif)|(\\.pdf)|(\\.wmi)|(\\.avi)|( {5}.*))\\.exe"
}
```

### Disable an Event at the Source
Turn off the sending of a specific event to the cloud. Useful to limit some verbose data sources when not needed.

**Detect**
```yaml
op: is windows
event: CONNECTED
```

**Respond**
```yaml
- action: task
  command: exfil_del NEW_DOCUMENT
```

### Monitoring Sensitive Directories
Make sure the File Integrity Monitoring of some directories is enabled whenever Windows sensors connect.

**Detection**
```yaml
event: CONNECTED
op: is windows
```

**Respond**
```yaml
- action: task
  command: fim_add --pattern "C:\\\\*\\\\Programs\\\\Startup\\\\*" --pattern "\\\\REGISTRY\\\\*\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Run*"
```

### Mention of an Internal Resource
Look for references to private URLs in proxy logs.

**Detection**
```yaml
target: artifact
op: contains
path: /text
value: /corp/private/info
```

**Respond**
```yaml
- action: report
  name: web-proxy-private-url
```

### De-duplicate Cloned Sensors
Sometimes users install a sensor on a VM image by mistake. This means every time a new instance
of the image gets started the same sensor ID (SID) is used for multiple boxes with different names.
When detected, LimaCharlie produces a [sensor_clone](events.md#sensor_clone) event.

We can use these events to deduplicate. This example targets Windows clones.

**Detection**
```yaml
target: deployment
event: sensor_clone
op: is windows
```

**Respond**
```yaml
- action: task
  command: file_del %windir%\\system32\\hcp.dat
- action: task
  command: file_del %windir%\\system32\\hcp_hbs.dat
- action: task
  command: file_del %windir%\\system32\\hcp_conf.dat
- action: task
  command: restart
```

# False Positive Rules

The False Positive (FP) rules allow you to filter out detections (as generated by the `report` action).
These rules apply globally across all `namespaces` and sources.

## Use Cases

The typical use case for FP rules is to add exceptions from some detections that are cross-cutting (for
example ignore all detections from a specific host), organization-specific exceptions (like ignoring
alerts relating to a custom piece of software used in an organization), or suppressing errors from
managed D&R rules you don't have direct access to.

## Structure

An FP rule is structured with the same format at the `detection` component of a D&R rule. The main
difference is that the rule applies to the content of a detection, as can be seen in the Detections
section of the web app.

Most stateless operators from the D&R rules are available in FP rules.

## Examples

### Suppress a Specific Detection

Prevent a specific detection:

```yaml
op: is
path: cat
value: my-detect-name
```

### Ignore Detections for Specific File Name

Ignore any detection that relates to a file name in any path.

```yaml
op: ends with
path: detect/event/FILE_PATH
value: this_is_fine.exe
```

### Ignore Detections on a Specific Host

Any detection originating from a specific host will be ignore.

```yaml
op: is
path: routing/hostname
value: web-server-2
```
