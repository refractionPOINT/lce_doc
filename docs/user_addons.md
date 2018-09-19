# User Add-ons

[TOC]

## Overview
In LimaCharlie.io, the Add-ons marketplace is a place where you users can subscribe
to various capabilities as provided by other users.

Several categories of capabilities exists like Detections and Lookups:

* Detections are components you can use as part of [D&R rules](dr.md).
* Lookups are lists of values to match in incoming LC data along with metadata for each value. They are use as part of [D&R rules](dr.md) as well.

Users can create their own add-ons privately which gives them access to enable those
rules in organizations they are members of, or publicly where anyone in the marketplace
can subscribe.

## Using
In order to use add-ons, you must first subscribe to them with an organization.
To do this, go to the "Add-ons" menu in your organization, then go to the category
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
* Your email address will be included in the add-on description, if you plan on publishing
many rules you may want to create a limacharlie.io account specifically for this purpose.
* The platforms flags are not enforced but are a courtesy to the users to let them
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

### Lookups
Creating a lookup add-on enables you to create a list that you can use as part of [D&R rules](dr.md).
Once in place, you can refer to it using the `op: lookup` D&R rule with a reference to your add-on looking
like `resource: lcr://lookup/my-lookup-name`.

The lookup structure is very simple, it should be a dictionary where each key is a value that
can be matched while the value associated with the key is any type of metadata you would like
reported in association with this particular match. Here is an example:

```yaml
evil.com: some evil website, definitely bad
example.com:
  source: my-threat-intel
  risk: high
  contact: email threatintel@mycorp.com immediately if spotted
```

When a Lookup add-on is submitted via a URL callback instead of through the website, the
format pointed to by the URL must be in JSON format (still a dictionary). The maximum size
of a lookup fetched from a URL is 15MB and from the web is 512KB.