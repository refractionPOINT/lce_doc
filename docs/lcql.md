# LimaCharlie Query Language

LCQL is currently in Beta.

LCQL is designed to provide a flexible, intuitive and interactive way to explore data in LimaCharlie.

Although it is currently only implemented through the LimaCharlie CLI (`pip install limacharlie`)
as `limacharlie query --help`, in the future it will be adapter to be available directly through
the web interface.

## Query Structure
LCQL queries contain 4 components with a 5th optional one, each component is
separated by a pipe (`|`):
1.  Timeframe: the time range the query applies to. This can be either a single
    offset in the past like `-1h` or `-30m`. Or it can be a date time range
    like `2022-01-22 10:00:00 to 2022-01-25 14:00:00`.
2.  Sensors: the set of sensors to query. This can be either `*` for all sensors,
    a list of space separated SIDs like `111-... 222-... 333-...`, or it can
    be a [sensor selector](https://doc.limacharlie.io/docs/documentation/36c920f4f7bc9-sensor-selector-expressions)
    like `plat == windows`.
3.  Events: the list of events to include in the query, space separated like
    `NEW_PROCESS DNS_REQUEST`, or a `*` to go over all event types.
4.  Filter: the actual query filter. The filters are a series of statements
    combined with " and " and " or " that can be associated with parenthesis (`()`).
    String literals, when used, can be double-quoted to be case insensitive
    or single-quoted to be case sensitive.
    Selectors behave like D&R rules, for example: `event/FILE_PATH`.
    These are the currently supported operators:
    - `is` (or `==`) example:
        ```event/FILE_IS_SIGNED is 1 or event/FILE_PATH is "c:\windows\calc.exe"```
    - `is not` (or `!=`) example: `event/FILE_IS_SIGNED != 0`
    - `contains` example: `event/FILE_PATH contains 'evil'`
    - `not contains`
    - `matches` example: `event/FILE_PATH matches ".*system[0-9a-z].*"`
    - `not matches`
    - `starts with` example: `event/FILE_PATH starts with "c:\windows"`
    - `not starts with`
    - `ends with` example: `event/FILE_PATH ends with '.eXe'`
    - `not ends with`
    - `cidr` example: `event/NETWORK_CONNECTIONS/IP_ADDRESS cidr "10.1.0.0/16"`
    - `is lower than` example: `event/NETWORK_CONNECTIONS/PORT is lower than 1024`
    - `is greater than`
    - `is platform` example: `is platform "windows"`
    - `is not platform`
    - `is tagged` example: `is tagged "vip"`
    - `is not tagged`
    - `is public address` example:
        ```event/NETWORK_CONNECTIONS/IP_ADDRESS is public address```
    - `is private address`
    - `scope` example:
        ```event/NETWORK_CONNECTIONS scope (event/IP_ADDRESS is public address and event/PORT is 443)```
    - `with child` / `with descendant` / `with events` example:
        ```event/FILE_PATH contains "evil" with child (event/COMMAND_LINE contains "powershell")```
5.  Projection (optional): a list of fields you would like to extract from the results
    with a possible alias, like: `event/FILE_PATH as path event/USER_NAME AS user_name event/COMMAND_LINE`
    The Projection can also support a grouping functionality by adding ` GROUP BY (field1 field2 ...)` at the
    end of the projection statement. When grouping, all fields being projected must either be in the `GROUP BY`
    statement, or have an aggregator modifier. An aggregator modifer is, for example, `COUNT( host )` or
    `COUNT_UNIQUE( host )` instead of just `host`.
    A full example with grouping is:

    ```-1h | * | DNS_REQUEST | event/DOMAIN_NAME contains "apple" | event/DOMAIN_NAME as dns COUNT_UNIQUE(routing/hostname) as hostcount GROUP BY(dns host)```

    which would give you the number of hosts having resolved a domain containing `apple`, grouped by domain.

All of this can result in a query like:

```
-30m | plat == windows | NEW_PROCESS | event/COMMAND_LINE contains "powershell" and event/FILE_PATH not contains "powershell" | event/COMMAND_LINE as cli event/FILE_PATH as path routing/hostname as host
```


OR

```
-30m | plat == windows | * | event/COMMAND_LINE contains "powershell" and event/FILE_PATH not contains "powershell" |
```

## Examples

Show me all Windows boxes who have received network connections originating from the public internet in the last 10 minutes. Report the host, unique destination IP and port within the network, and the count of number of connections.

```
-10m | plat == windows | NETWORK_CONNECTIONS | event/NETWORK_ACTIVITY/SOURCE/IP_ADDRESS is public address | routing/hostname as host event/NETWORK_ACTIVITY/DESTINATION as dest COUNT_UNIQUE(event) as count GROUP BY(host dest)
```

which could result in:
```
|   count | dest                                     | host                                 |
|---------|------------------------------------------|--------------------------------------|
|       5 | {'IP_ADDRESS': '10.128.0.3', 'PORT': 22} | demo-debian.c.lc-demo-infra.internal |
|       2 | {'IP_ADDRESS': '10.0.0.4', 'PORT': 3389} | demo-machine                         |
```