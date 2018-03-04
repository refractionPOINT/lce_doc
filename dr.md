***[Back to documentation root](README.md)***

# Detection and Response

Detect lambdas are designed to allow you to push out a detection rule and with a custom action in record time.
Think of it like a `lambda` in various programming languages or in AWS. They can be added and removed with single operations
and they become immediately available/running as they are set. They are simple to read one-liners.

Besides using a lambda for matching on behaviors observed from sensors, you can also set a lambda that describes an
action that should be taken when those occur.

To give you a taste, here is a short term mitigation written for Wanacry written in about 2 minutes:

**Match**:
```python
event.Process( pathEndsWith = '@wanadecryptor@.exe' )
```

**Action**:
```python
sensor.task( [ 'deny_tree', event.atom ] ) and sensor.task( [ 'history_dump' ] ) and report( name = 'wanacry' )
```

## Matching Rules
A matching rule that evaluates to `True` will "fire" the associated action (described below). The rule has available to it the `event` object that represents the event being evaluated, and the `sensor` object that has an `aid` variable that is the Agent Id where the event originates, and an `sensor.isTagged( "tag_name" )` method.

### Event Selection
`event.Process()`: the rule will only apply to events that contain process information.

`event.ParentProcess()`: access the parent process of the event, if it is contained within the same event.

`event.Dns()`: the rule will only apply to `DNS_REQUEST` events.

`event.Hash()`: the rule will only apply to events that report the hash of a piece of code.

`event.NetworkSummary()`: the rule will only apply to `NETWORK_SUMMARY` events.

`event.Connections()`: the rule will only apply to events that contain network connection information.

`event.UserObserved()`: the rule will only apply to `USER_OBSERVED` events.

`event.StartingUp()`: the rule will only apply to `STARTING_UP` events.

`event.Sync()`: the rule will only apply to `SYNC` events.

### Characteristic Selection
`path = `: the file path equals.

`pathEndsWith = `: the file path ends with.

`pathStartsWith = `: the file path starts with.

`pathMatches = `: the file path matches the regular expression.

`commandLine = `: the process command line equals.

`commandLineEndsWith = `: the process command line ends with.

`commandLineStartsWith = `: the process command line starts with.

`commandLineMatches = `: the process command line matches the regular expression.

`user = `: the user name equals.

`userEndsWith = `: the user name ends with.

`userStartsWith = `: the user name starts with.

`userMatches = `: the user name matches the regular expression.

`domain = `: the domain name equals.

`domainEndsWith = `: the domain name ends with.

`domainStartsWith = `: the domain name starts with.

`domainMatches = `: the domain name matches the regular expression.

`cname = `: the CNAME (in a DNS request) equals.

`cnameEndsWith = `: the CNAME (in a DNS request) ends with.

`cnameStartsWith = `: the CNAME (in a DNS request) starts with.

`cnameMatches = `: the CNAME (in a DNS request) matches the regular expression.

`ip = `: the IP address equals.

`ipEndsWith = `: the IP address ends with.

`ipStartsWith = `: the IP address starts with.

`ipIn = `: the IP address is within the network (CIDR notation).

`hash = `: the hash (sha256) equals.

`userId = `: the user id (as in 0 == `root`) equals.

`dstIpIn = `: the destination IP address is within the network (CIDR notation).

`srcIpIn = `: the source IP address is within the network (CIDR notation).

`dstPort = `: the destination port equals.

`srcPort = `: the source port equals.

`isOutgoing = `: the network connection is outgoing.

### Sensor Object
The `sensor` object in the matching part and the action part support the following:
* Send a command to the sensor: `sensor.Task( [ 'command', 'with', 'arguments' ], inv_id = 'some-id-to-include-in-related-events' )`.
* Tag, untag and test tag presence: `sensor.tag( 'a-tag' )`, `sensor.untag( 'another-tag' )` and `sensor.isTagged( 'a-tag' )`.
* Test to see if in organization: `sensor.inOrg( 'org_id' )`.
* Test platform and architecture: `sensor.isWindows`, `sensor.isMacOSX`, `sensor.isLinux`, `sensor.is32Bit` and `sensor.is64Bit`.
* The raw full agent id: `sensor.aid`.

General routing information on the sensor: `sensor.routing` where routing is a dictionary containing the following:
* Organization Id: `sensor.routing.oid`.
* Installer Id: `sensor.routing.iid`.
* Sensor Id: `sensor.routing.sid`.
* Host Name: `sensor.routing.hostname`.
* Internal IP: `sensor.routing.int_ip`.
* External IP: `sensor.routing.ext_ip`.
* Event Time: `sensor.routing.event_time`.
* Event Id: `sensor.routing.event_id`.

### Event Object
Beyond the basic matching described above, the `event` object can do:

Raw event data: `event.data`.
Event type name: `event.dataType`.
Get the atoms to relate events: `event.atom` and `event.parentAtom`.

### Helpers
Some other simple helper functions are available both in detection and action:

A `virustotal( hash )` to get a VirusTotal report for a hash (dictionary of AV engines reporting Bad).

A `geolocate( ip )` to get information on the geolocation of an IP as reported by [ip-api](https://ip-api.com).

A `malwaredomains( domain )` to get information on a domain from [malwaredomains.com](https://malwaredomains.com).

A `coinblockerlists( domain )` to know if a domain is present in the lists from [CoinBlockerLists](https://zerodot1.github.io/CoinBlockerLists/).

### Examples
`event.Dns( domainEndsWith = ".3322.org" ) and sensor.isTagged( "server" )`: matches all DNS requests to a domain ending with `.3322.org` and where the sensor has the "server" tag.

`event.Process( pathEndsWith = "Google Chrome Helper" ) and event.Connections( dstPort = 1900 )`: matches all processes who's name ends with `Google Chrome Helper`, and which have a network connection to port `1900`, note that this indirectly refers to a `NETWORK_SUMMARY` event since they are the only ones containing both a network connection and process information.

## Action
The action states what should happen when the matching rule "fires". It has access to the `event` object (like the Matching rules) and the `sensor` object.

The `sensor` object can also `sensor.tag( "new_tag" )` (or `.untag( "old_tag" )`) to apply a new tag to the sensor, and `sensor.task( [ "command", "arg1", ... ] )` to send a tasking to the sensor. The actual commands are documented in the command line interface `admin_cli.py` that can be found [here](https://github.com/refractionPOINT/lc_cloud/blob/master/beach/hcp/admin_cli.py#L703).

A `report( name = "detection_name", content = event, mtd = new_info, isPublish = True )` function to create a detect.

A `page( to = "some@gmail.com", subject = "email subject", data = event )` to send an email page somewhere.

## Details

Additionally, complete event data is available through the `event.data` and metadata through `event.mtd`.

More complex stateless detections, loaded by URL (like `https://...` or `file://...`) are available. To load
one, simple put the file URL in the `rule` section instead of a lambda. The file must contain a class named the same
name as the file. This class must have a prototype like this:

```python
class SomeStatelessDetection( object ):
    def __init__( self, fromActor ):
        # fromActor is a reference to the Actor running this, use it to get Beach virtual handles etc.
        pass

    def analyze( self, event, sensor, *args ):
        pass
```

Stateful detections are only available through the loading of a file (not lambdas) as mentioned above. The prototype
for this is:

```python
class SomeStatefulDetection( object )
    def __init__( self, fromActor ):
        # fromActor is a reference to the Actor running this, use it to get Beach virtual handles etc.
        pass

    def getDescriptor( self ):
        # This must return a single StateMachineDescriptor() as with the old Stateful detections.
        pass
```

More complex actions, loaded by URL are available. To load one, simple put the file URL in the `action` section
instead of a lambda. The file must contain a class named the same name as the file. This class must have a prototype
like this:

```python
class SomeHunter( object )
    def __init__( self, fromActor ):
        # fromActor is a reference to the Actor running this, use it to get Beach virtual handles etc.
        pass

    def respond( self, event, sensor, context, report, page, *args ):
        pass
```

Finally, a `rule` section (lambda or complex file-based stateless detection) may return a `tuple()` instead of a
simple boolean. If that is the case, the first element of the tuple is a `True`/`False` indication of whether a
match was successful, and the second element is a context that will be passed to the `action` section as a variable
named `context` like: `( event.Process( pathEndsWith = ".evil" ), event.data.values()[ 0 ][ "base.FILE_PATH" ] )` to
match on processes with a path ending in `.evil` and giving the `action` section a `context` equal to the actual path
in the event.

## Use Cases

| Case | Matching Rule | Action |
| ---- | ------------- | ------ |
| Tagging a sensor when a user logs in, like VIPs. | `event.UserObserved( user = 'ceo' )` | `sensor.tag( 'vip' )` |
| Tagging a sensor when a process executes, like Developers. | `event.Process( pathEndsWith = 'devenv.exe' )` | `sensor.tag( 'developer' )` |
| Stop WanaCry (ransomware), get context events and report the detection. | `event.Process( pathEndsWith = '@wanadecryptor@.exe' )` | `sensor.task( [ 'deny_tree', event.atom ] ) and sensor.task( [ 'history_dump' ] ) and report( name = 'wanacry', content = event )` |
| Send an email any time a domain admin account is used outside of domain controllers. | `event.Process( user = 'mydomain\\domainadmin' ) and not sensor.isTagged( 'domain_controller' )` | `page( to = 'security@mydomain.com subject = 'Suspicious Domain Admin Activity' data = event ) and sensor.task( [ 'history_dump' ] )` |
| Detect if an executable running as root gets a connection on port 80. | `event.Process( userId = 0 ) and event.Connections( srcPort = 80, isOutgoing = False )` | `report( name = 'root_in_80', content = event ) and sensor.task( [ 'history_dump' ] )` |
| Segregate the network if a bitcoin miner domain is accessed by anyone except servers. | `coinblockerlists( event ) and not sensor.isTagged( 'server' )` | `report( 'bitcoin-minor-segregated' ) and sensor.task( [ 'segregate_network' ] )` |

## Creating Rules
* REST: `POST` to the `/rules`
* RPC: `./rpc.py analytics/dr add_rule -d "{ 'name' : 'rule name', 'rule' : 'event.UserObserved( user = \'ceo\' )', 'action' : 'sensor.tag( \'vip\' )', 'by' : 'user 1' }"`

## Deleting Rules
* REST: `DELETE` to the `/rules`
* RPC: `./rpc.py analytics/dr del_rule -d "{ 'name' : 'rule name', 'by' : 'user 1' }"`

## Listing Rules
* REST: `DELETE` to the `/rules`
* RPC: `./rpc.py analytics/dr get_rules`
