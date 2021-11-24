# Using API-Based Lookups

## Mechanics

Functionally, API-based lookups operate exactly the same as using the normal [`lookup` operator](operators.md#lookup), with one addition: `metadata_rules`. The rule will pass a value to the lookup, wait for a response, and then evaluate the response using `metadata_rules`.

The operators within `metadata_rules` are evaluated exactly the same as any other rule, except they additionally evaluate the lookup's response. The response actions will only run if the `metadata_rules` criteria are met.

## Available Lookups

### VirusTotal

With the [`vt` add-on](https://app.limacharlie.io/add-ons/detail/vt) subscribed and a VirusTotal API Key configured in the Integrations page, VirusTotal can be used as an API-based lookup.

```yaml
event: CODE_IDENTITY
op: lookup
path: event/HASH
resource: 'lcr://api/vt'
metadata_rules:
  op: is greater than
  value: 1
  path: /
  length of: true
```

Step-by-step, this rule will do the following:

* Upon seeing a `CODE_IDENTITY` event, retrieve the `event/HASH` value and send it to VirusTotal via the `api/vt` resource
* Upon receiving a response from `api/vt`, evaluate it using `metadata_rules` to see if the length of the response is greater than 1 (in this case meaning that more than 1 vendor reporting a hash is bad)

> If your VirusTotal API Key runs out of quota, hashes seen until you have quota again will be ignored.

### IP GeoLocation

With the [`ip-geo` add-on](https://app.limacharlie.io/add-ons/detail/ip-geo) subscribed, it can be used as an API-based lookup.

```yaml
event: CONNECTED
op: lookup
resource: 'lcr://api/ip-geo'
path: routing/ext_ip
metadata_rules:
  op: is
  value: true
  path: country/is_in_european_union
```

Step-by-step, this rule will do the following:

* Upon seeing a `CONNECTED` event, retrieve the `routing/ext_ip` value and send it to MaxMind via the `api/ip-geo` resource
* Upon receiving a response from `api/ip-geo`, evaluate it using `metadata_rules` to see if the country associated with the IP is located in the EU

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
The geolocation data comes from GeoLite2 data created by [MaxMind](http://www.maxmind.com).