# Replay

[TOC]

## Overview
Replay allows you to run [Detection & Response (DR) rules](dr.md) against traffic.
This can be done in a few combinations of sources:

Rule Source:
* Existing rule in the organization, by name.
* Rule in the replay request.

Traffic:
* Sensor historical traffic.
* Local events provided during request.

## Using

Using the Replay API requires the [API key](api_keys.md) to have the following permissions:
* `dr.list`

If the traffic source is from an organization, the following additional permissions are required:
* `insight.evt.get`
* `insight.det.get`

The returned data from the API contains the following:
* `responses`: a list of the actions that would have been taken by the rule (like `report`, `task`, etc).
* `num_evals`: a number of evaluation operation performed by the rule. This is a rough estimate of the performance of the rule.
* `num_events`: the number of events that were replayed.
* `eval_time`: the number of seconds it took to replay the data.

### Python CLI
The [Python CLI](https://github.com/refractionPOINT/python-limacharlie) gives you a friendly way to replay data, and to do so across larger datasets
by automatically splitting up your query into multiple queries that can run in parallel.

Sample command line to query one sensor:
```
limacharlie-replay --sid 9cbed57a-6d6a-4af0-b881-803a99b177d9 --start 1556568500 --end 1556568600 --rule-content ./test_rule.txt
```

Sample command line to query an entire organization:
```
limacharlie-replay --entire-org --start 1555359000 --end 1556568600 --rule-name my-rule-name
```

If specifying a rule as content with the `--rule-content`, the format should be
in `JSON` or `YAML` like:
```
detect:
  event: DNS_REQUEST
  op: is
  path: event/DOMAIN_NAME
  value: www.dilbert.com
respond:
  - action: report
    name: dilbert-is-here
```

Instead of specifying the `--entire-org` or `--sid` flags, you may use events from
a local file via the `--events` flag.

We invite you to look at the command line usage itself as the tool evolves.

### REST API
The Replay API is available to all DataCenter locations using a per-location URL.
To get the appropriate URL for your organization, use the REST endpoint to
retrieve the URLs found [here](https://api.limacharlie.io/static/swagger/#/LimaCharlie_Cloud/get_orgs__oid__url).
named `replay`.

Having per-location URLs will allow us to guarantee that processing occurs within the
geographical area you chose. Do not that currently some locations are NOT guaranteed
to be in the same area due to the fact we are using the Google Cloud Run product that
is not available globally. For these cases, processing is current done in the United States
but as soon as it becomes available in your area, the processing will be moved transparently.

Authentication to this API works with the same JWTs as the main limacharlie.io API.

For this example, we will use the experimental datacenter's URL:
```
https://0651b4f82df0a29c.replay.limacharlie.io/sensor/
```

The API mainly works on a per-sensor basis, on a limited amount of time. Replaying for
multiple sensors (or entire org), or longer time period is done through multiple
parallel API calls. This multiplexing is taken care of for you by the Python CLI above.

Specify which Organization ID (`OID`) and Sensor ID (`SID`) through the following URI:
```
https://0651b4f82df0a29c.replay.limacharlie.io/sensor/{OID}/{SID}
```

Specify the `start` and `end` time range, as unix second epoch in the query string:
```
https://0651b4f82df0a29c.replay.limacharlie.io/sensor/{OID}/{SID}?start={START_EPOCH}&end={END_EPOCH}
```

Specify the rule to apply. This can be done via a `rule_name` query string parameter, or
by supplying the rule, as `JSON` in the body of the `POST` and a `Content-Type` header of `application-json`:
```
https://0651b4f82df0a29c.replay.limacharlie.io/sensor/{OID}/{SID}?start={START_EPOCH}&end={END_EPOCH}&rule_name={EXISTING_RULE_NAME}
```

You may also use events provided during the request by using the endpoint:
```
https://0651b4f82df0a29c.replay.limacharlie.io/simulate/{OID}
```
The body of the `POST` should be a `JSON` blob like:
```
{
  "rule": {...},
  "events": [
    ...
  ]
}
```
Like the other endpoints you can also submit a `rule_name` in the URL query if you want
to use an existing organization rule.
