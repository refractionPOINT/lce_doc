
# Lookups

Creating a lookup add-on enables you to create a list that you can use as part of [D&R rules](dr.md).
Once in place, you can refer to it using the `op: lookup` D&R rule with a reference to your lookup looking
like `resource: hive://lookup/my-lookup-name`.

Lookups are often used as a "threat feed", looking for bad indicators. But they can be used in different
contexts by changing the Response component of the D&R rules that use them.

Lookups are always compared for exact matches, but if you specify the `case sensitive: false` modifier
when using the lookup as part of a D&R rule, the value will be set to all lower-case for you (making
it easier for you to create a lower-case lookup and therefore being case insensitive).

## Final Structure

Fundamentally, all lookups get converted into a dictionary of string to dictionaries, where the string
is the element to be looked up, and the value for each is a dictionary of optional metadata to report
when the lookup returns a hit.

Example:
```json
{
  "evil.com": {
    "source": "some thread feed",
    "priority": 3
  },
  "3322.org": {
    "source": "from a tlp thread",
    "priority": 3,
    "author": "john@smith.com"
  },
  "eviler.net": {
    "source": "twitter",
    "priority": 1,
    "twitter_link": "..."
  }
}
```

## Ingestion

Although the final format is JSON as described above, lookups can be ingested from various formats.
Creating a lookup is done through the `lookup` [hive](hive.md). The record format to use when storing
in Hive should be by providing one of the following fields:

```json
{
  "lookup_data": {}, // This is the same as the final format of lookups. So you can ingest it directly in its final form.
  // Parsed formats: this allows you to specify the data in different formats which LimaCharlie will parse into its final form.
  "newline_content": "", // A simple set of newline-separated values which will be come keys of the lookup. The metadata component will be empty ({}).
  "yaml_content": "", // This is the same format as the final "lookup_data", except provided as a YAML document.
}
```

If you have some formats that would make your life easier, please get in touch with us so we can add support directly here.

Here's a few one-liner examples of ingesting data into LimaCharlie using the CLI tool:

```bash
# As newline format
echo -e '{"newline_content": "evil.com\n3322.org\neviler.net"}' | limacharlie hive set lookup --key my-lookup --data -

# As YAML format with metadata
echo -e '{"yaml_content": "3322.org:\n  author: john@smith.com\n  priority: 3\n  source: from a tlp thread\nevil.com:\n  priority: 3\n  source: some thread feed\neviler.net:\n  priority: 1\n  source: twitter\n  twitter_link: something"}' | limacharlie hive set lookup --key my-lookup --data -
```

#### Reference D&R Rules
To put a Lookup "into effect", you need a [D&R rule](dr.md). The Lookup is a list of elements while
the rule describes what you want to look for in that list.

Referring to lookups uses the format: `hive://lookup/my-lookup-name`.

Below is a list of D&R rules as examples of how to lookup various common Indicators of Compromise:

##### Hashes

```yaml
op: lookup
event: CODE_IDENTITY
path: event/HASH
resource: 'hive://lookup/my-hash-lookup'
```

##### Domain Names

```yaml
op: lookup
event: DNS_REQUEST
path: event/DOMAIN_NAME
resource: 'hive://lookup/my-dns-lookup'
```

##### IP Addresses

```yaml
op: lookup
event: NETWORK_CONNECTIONS
path: event/NETWORK_ACTIVITY/?/IP_ADDRESS
resource: 'hive://lookup/my-ip-lookup'
```
