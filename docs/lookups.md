
# Lookups

Creating a lookup add-on enables you to create a list that you can use as part of [D&R rules](dr.md).
Once in place, you can refer to it using the `op: lookup` D&R rule with a reference to your add-on looking
like `resource: lcr://lookup/my-lookup-name`.

Lookups support a few structures.

* Newline-separated values.
* JSON dictionary where keys are the elements of the lookup and the values are the metadata associated.
* YAML dictionary where keys are the elements of the lookup and the values are the metadata associated.
* OTX JSON Pulse.
* MISP JSON Feed.

Here is an example of this complex format:
```yaml
evil.com: some evil website, definitely bad
example.com:
  source: my-threat-intel
  risk: high
  contact: email threatintel@mycorp.com immediately if spotted
```

When uploaded, the data for the lookup can be provided in three different ways:

1. As data literal in the upload API.
1. As a URL callback, where your data is a URL like https://www.my.data.
1. As an [Authenticated Resource Locator (ARL)](arl.md) (the preferred method)

The maximum size of a lookup is 15MB through the REST API and 512KB through the web interface.

## Optimized Format
Sometimes when creating a Lookup you may want to include correct metadata for each element
of the lookup, but the maximum size may be an issue. In cases where there is a lot of metadata
repetition you may use an optimized format. This format will allow you to associate large
pieces of metadata with a high number of lookup items.

To accomplish this, you will need to split up your metadata from your lookup values like:

```json
{
  "_LC_METADATA": [
    {
      "some": "metadata",
      ...
    }, {
      "some": "moremetadata",
      ...
    }, {
      "somemore": "metadata",
      ...
    }
  ],
  "_LC_INDICATORS: {
    "evil.exe": 0,
    "another.exe": 0,
    "more.exe": 1,
    "vals.exe": 2,
    ...
  }
}
```

The `_LC_METADATA` key has as a value, a list of all the pieces of metadata you want to include.

The `_LC_INDICATORS` is the normal list of indicators, but instead of having the metadata directly
associated with each indicator as the value, it uses an integer that refers to the `_LC_METADATA`
list's index where the metadata can be found.

The above example is equivalent to the non-optimized:

```json
{
  "evil.exe": {
      "some": "metadata",
      ...
    },
  "another.exe": {
      "some": "metadata",
      ...
    },
  "more.exe": {
      "some": "moremetadata",
      ...
    },
  "vals.exe": {
      "somemore": "metadata",
      ...
    },
}
```

As you can see, this optimization is useful to reduce the repeated metadata. This is particularly
useful if, for example, you have large numbers of IoCs for a given actor. In that case, every
IoC in the lookup would be associated with the same metadata (information about the actor).

#### From MISP
When creating an add-on from MISP content, LimaCharlie expects the data to be a JSON document
to have the following structure:

```json
{
  "Event": {
    "uuid": "fa781e8e-4332-4ff7-8286-f44445fb6f3a",
    "Attribute": [
      {
        "uuid": "e9e6840a-ff90-4fbd-8ef1-f5b766adbbce",
        "value": "evil.com"
      },
      ...
    ]
  }
}
```

The MISP event above once ingested in LC will be transformed to a Lookup like:

```json
{
  "evil.com": {
    "misp_event": "fa781e8e-4332-4ff7-8286-f44445fb6f3a",
    "attribute": "e9e6840a-ff90-4fbd-8ef1-f5b766adbbce"
  },
  ...
}
```

LimaCharlie understand the MISP format, regardless of how it is ingested. That being
said, the classic way of ingesting it would be to ingest the MSIP Events use an [ARL](https://github.com/refractionPOINT/authenticated_resource_locator)
on a MISP REST API with one of the supported ARL authentication types like `basic`.

For example: `[https,misp.my.corp.com/events/1234,basic,myuser:mypassword]`.

#### Reference D&R Rules
To put a Lookup "into effect", you need a [D&R rule](dr.md). The Lookup is a list of elements while
the rule describes what you want to look for in that list.

Below is a list of D&R rules describing how to lookup various common Indicators of Compromise:

##### Hashes

```yaml
op: lookup
event: CODE_IDENTITY
path: event/HASH
resource: 'lcr://lookup/my-hash-lookup'
```

##### Domain Names

```yaml
op: lookup
event: DNS_REQUEST
path: event/DOMAIN_NAME
resource: 'lcr://lookup/my-dns-lookup'
```

##### IP Addresses

```yaml
op: lookup
event: NETWORK_CONNECTIONS
path: event/NETWORK_ACTIVITY/?/IP_ADDRESS
resource: 'lcr://lookup/my-ip-lookup'
```
