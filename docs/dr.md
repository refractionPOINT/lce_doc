# Detection & Response Rules

Detection & Response rules automate actions based on the real-time events streaming into LimaCharlie. Each rule has two YAML descriptors: one that describes what to detect, and another that describes how to respond.

> It's recommended to read about [Events](events-overview.md) before diving into D&R rules.

## A Basic Rule

Here's a rule that detects DNS requests to `example.com` and responds by reporting them within the organization with a category name `DNS Hit example.com`.

```yaml
# Detection
event: DNS_REQUEST
op: is
path: event/DOMAIN_NAME
value: example.com

# Response
- action: report
  name: DNS Hit example.com
```

This rule will detect and respond to requests to `example.com` within 100ms of the `DNS_REQUEST` event occurring. It uses the `is` operator to assess if the given `value` can be found inside the `event` at the given `path`. 

> Just want examples? Check out the [Examples](dr-examples.md) page.

## Detection

### Targets and events

Detections must specify an `event` (or `events`), and may optionally specify a `target`. Each target offers different event types. Here are the 4 possible rule targets:

- `edr` (default): telemetry events from LimaCharlie sensors
- `deployment`: lifecycle events around deployment & enrollment of sensors
- `artifact`: artifacts collected via REST API or via `artifact_get` sensor command
- `artifact_event`: lifecycle events around artifacts such as ingestion

> For a full list of events with examples, see [Reference: Events](events.md).

> Most of this page focuses on `edr` events. For information about other targets, see [Detection on Alternate Targets](detection-on-alternate-targets.md).

### Operators

Detections must specify an `op` (logical operator). The types of operators used are a good indicator for how complex the rule will be.

Here's a simple detection that uses a single `is windows` operator to detect a Windows sensor connecting to the Internet:

```yaml
event: CONNECTED
op: is windows
```

And here's a more complex detection that uses the `and` operator to detect a non-Windows sensor that's making a DNS request to example.com.

```yaml
event: DNS_REQUEST
op: and
rules:
- op: is windows
  not: true
- op: is
  path: event/DOMAIN_NAME
  value: example.com
```

There are 3 operators here:

1. The `and` operator evaluates nested `rules` and will only itself be `true` if both of the rules inside it are `true`
2. The `is windows` operator is accompanied by the `not` parameter, reversing the matching outcome and effectively saying "anything but windows"
3. The `is` operator is comparing the `value` 'example.com' to the content of the event at the given `path`

Each operator may have parameters alongside it. Some parameters, such as `not`, are useable on all operators. Most operators have required parameters specific to them. 

> For a full list of operators and their usage, see [Reference: Operators](operators.md).

### Paths

The `path` parameter is used commonly in several operators to specify which part of the event should be evaluated.

Here's an example of a standard JSON `DNS_REQUEST` event from a sensor:

```json
{
  "event": {
    "DNS_TYPE": 1,
    "TIMESTAMP": 1456285240,
    "DNS_FLAGS": 0,
    "DOMAIN_NAME": "example.com"
  },
  "routing": {
    "event_type": "DNS_REQUEST",
    "oid": "8cbe27f4-agh1-4afb-ba19-138cd51389cd",
    "sid": "d3d17f12-eecf-5287-b3a1-bf267aabb3cf",
    "hostname": "test-host-123"
    // ...and other standardized routing data
  }
}
```

This detection will match the above event's hostname:

```yaml
event: DNS_REQUEST
op: is
path: routing/hostname # where the value lives
value: test-host-123   # the expected value at that path
```

This works a lot like file paths in a directory system. Since LimaCharlie events are always formatted with separate `event` and `routing` data, almost all paths start with either `event/` or `routing/`. 

> Tip: you can visit the Timeline view of any Sensor to browse historical events and bring them directly into the D&R rule editor.

Paths may also employ the use of wildcards `*` to represent 0 or more directory levels, or `?` to represent exactly 1 directory level. This can be useful when working with events like `NETWORK_CONNECTIONS`:

```json
{
  "event": {
    "NETWORK_ACTIVITY": [
      {
        "SOURCE": {
          "IP_ADDRESS": "172.16.223.138",
          "PORT": 50396
        },
        "IS_OUTGOING": 1,
        "DESTINATION": {
          "IP_ADDRESS": "23.214.49.56",
          "PORT": 80
        }
      },
      {
        "SOURCE": {
          "IP_ADDRESS": "172.16.223.138",
          "PORT": 50397
        },
        "IS_OUTGOING": 1,
        "DESTINATION": {
          "IP_ADDRESS": "189.247.166.18",
          "PORT": 80
        }
      },
      // ...there could be several connections
    ],
    "HASH": "2de228cad2e542b2af2554d61fab5463ecbba3ff8349ba88c3e48637ed8086e9",
    "COMMAND_LINE": "C:\\WINDOWS\\system32\\msfeedssync.exe sync",
    "PROCESS_ID": 6968,
    "FILE_IS_SIGNED": 1,
    "USER_NAME": "WIN-5KC7E0NG1OD\\dev",
    "FILE_PATH": "C:\\WINDOWS\\system32\\msfeedssync.exe",
    "PARENT_PROCESS_ID": 1892
  },
  "routing": { ... } // Omitted for brevity
}
```

Notice that the `NETWORK_ACTIVITY` inside this event is a list. 

Here's a rule that would match a known destination IP in any of the entries within `NETWORK_ACTIVITY`:

```yaml
event: NETWORK_CONNECTIONS
op: is
path: event/NETWORK_ACTIVITY/?/DESTINATION/IP_ADDRESS # <---
value: 189.247.166.18
```

The `?` saves us from enumerating each index within the list and instead evaluates *all* values at the indicated level. This can be very powerful when used in combination with lookups: lists of threat indicators such as known bad IPs or domains.  

> To learn more about using lookups in detections, see the [`lookup` operator](operators.md#lookup).

### Values

The `value` parameter is commonly used by several detection operations but can also be used by some response actions as well.

In most detections `value` will be used to specify a known value like all the previous examples on this page have done. They're also capable of referencing previously set sensor variables using `value: [[var-name]]` double square bracket syntax.

Values from events can also be forwarded in response actions using `value: <<event/FILE_PATH>>` double angle bracket syntax.

> To see how sensor variables and lookback values are used, see the [`add var / del var`](actions.md#add-var-del-var) action in [Reference: Actions](actions.md).

## Response

Responses are much simpler than Detections. They're a list of actions to perform upon a matching detection. 

### Actions

The most common action is the `report` action, which creates a Detection that shows up in the LimaCharlie web app and passes it along to the `detections` output stream in real-time.

```yaml
- action: report
  name: detected-something
```

Each item in the response specifies an `action` and any accompanying parameters for that `action`.

> To learn about all possible actions, see [Reference: Actions](actions.md).

## Putting It All Together

Let's take this knowledge and write a rule to detect something a little more interesting. 

On Windows there's a command, `[icacls](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/icacls)`, which can be used to modify access control lists. Let's write a rule which detects any tampering via that command. 

The first thing we can do is detect any new `icacls` processes:

```yaml
event: NEW_PROCESS
op: ends with
path: event/FILE_PATH
value: icacls.exe
```

And we'll set a basic response action to report the detection, too:

```yaml
- action: report
  name: win-acl-tampering
```

With that in place we'll see detections for any interactions with `icacls` . However, not all of them will be particularly interesting from a security perspective. In this case, we only really care about invocations of `icacls` where the `grant` parameter is specified. This way we can only get notified when new access is being granted on a box. 

We'll need a more specific rule which combines multiple operators: a perfect case for an `and` operator. While we're at it, we can also make sure we don't bother evaluating other platforms by specifying `is windows` too. 

```yaml
event: NEW_PROCESS
op: and
rules:
- op: is windows
- op: ends with
	path: event/FILE_PATH
	value: icacls.exe
- op: contains
  path: event/COMMAND_LINE
  value: grant
```

This more specific rule means we'll see fewer false positives to look at or exclude later. 

However, we still might miss some invocations of `icacls` with this detection if they use any capital letters — our operators are being evaluated with an implicit `case sensitive: true` by default. Let's turn case sensitivity off and observe the final rule:

```yaml
# Detection
event: NEW_PROCESS
op: and
rules:
- op: is windows
- op: ends with
	case sensitive: false
	path: event/FILE_PATH
	value: icacls.exe
- op: contains
	case sensitive: false
  path: event/COMMAND_LINE
  value: grant

# Response
- action: report
  name: win-acl-tampering
```

This rule combines multiple operators to specify the exact conditions which might make an `icacls` process interesting, reporting it as a `win-acl-tampering` detection so we can investigate.

## Going Deeper

This article gives an introduction to D&R rules, but their capabilities go much deeper. For further learning, here are some suggested readings:

- [Examples](dr-examples.md)
- [False Positive Rules](false-positive-rules.md)
- [Reference: Events](events.md)
- [Reference: Operators](operators.md)
- [Reference: Actions](actions.md)
- [Detection on Alternate Targets](detection-on-alternate-targets.md)
- [Detecting Related Events](detecting-related-events.md)
- [Using API-Based Lookups](api-lookups.md)
