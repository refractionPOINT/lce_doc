# User Add-ons

## Overview
In LimaCharlie.io, the Add-ons marketplace is a place where users can subscribe
to various capabilities as provided by other users.

Several categories of capabilities exist like Detections and Lookups:

* Detections are components you can use as part of [D&R rules](dr.md).
* Lookups are lists of values to match incoming LC data along with metadata for each value. They are used as part of [D&R rules](dr.md) as well.

Users can create their own add-ons privately which gives them access to enable those
rules in organizations they are members of, or publicly where anyone in the marketplace
can subscribe.

## Using
In order to use add-ons, you must first subscribe to them with an organization.
To do this, go to the "Add-ons" menu in your organization, then go to the category,
and find the add-on you want to subscribe to. Click on the subscribe switch.

After a second you will get a confirmation the add-on has been enabled for your organization.

Now go to the "D&R Rules" menu and create a rule using the add-on by using the relevant
operation (`external` or `lookup`) and specifying the resource as the add-on URL.

The add-on URL is simply a path like an HTTP URL, but starting with `lcr://` (for LimaCharlie Resource)
The next component of the path is the category of add-on (`lookup` or `detection`) and
finally the add-on name. So a path can look something like this:

```
lcr://detection/win-suspicious-exec-location
```

## Creating

Users can create their own add-ons and optionally share them in the marketplace.

To create a new add-on, do it from the dashboard of LimaCharlie.io. When doing
so, especially when marking the add-on as public, keep these in mind:

* Fill in as many of the fields as possible.
* Make the purpose and usage of the add-on clear for users not aware of the capability.
* If the add-on requires a lot of background information, put it in the website link
rather than the description.
* Your email address will be included in the add-on description. If you plan on publishing
many rules, you may want to create a limacharlie.io account specifically for this purpose.
* The platforms flags are not enforced, but are a courtesy to the users to let them
know where they can expect your add-on to work.
* Subscribers to your add-on will NOT have access to the exact implementation, this helps
you protect specific Intellectual Property you may have, but it also means you need to be clear
about the exact capabilities in your description and website.
* Add-ons remain your property, but may be evaluated and approved / dismissed due to
quality or performance concerns. If you are not sure, contact us at support@limacharlie.io.
* If implementing a detection, include "filtering" of the relevant event types to what is strictly
required for the detection, but avoid filtering on organization-defined labels as they change from
organization to organization. If you do use labels, describe the exact usage in the description.
* Before making an add-on public, make sure to test it.

***Keep in mind that creating an add-on does not immediatly grant the organizations you're a member of
access to it. After creating it, you must go in the organization you want to access it from, go to
the Add-ons section and "subscribe" to your add-on. This will grant the organization access and then
you can begin using it as part of D&R rules.***

### Lookups
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

#### Optimized Format
Sometimes when creating a Lookup you may want to include correct metadata for each element
of the lookup, but the maximum size may be an issue. In cases where there is a lot of metadata
repetition you may use an optimized format. This format will allow you to associate large
pieces of metadata with a high number of lookup items.

To accomplish this, you will need to split up your metadata from your lookup values like:

```
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

```
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
