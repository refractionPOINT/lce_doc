# Replay

## Overview
Replay allows you to run [Detection & Response (DR) rules](dr.md) against historical traffic.
This can be done in a few combinations of sources:

Rule Source:

* Existing rule in the organization, by name.
* Rule in the replay request.

Traffic:

* Sensor historical traffic.
* Local events provided during request.

## Using

Using the Replay API requires the [API key](api_keys.md) to have the following permissions:

* `insight.evt.get`

The returned data from the API contains the following:

```json
{
  "error": "",        // if an error occured.
  "stats": {
    "n_proc": 0,      // the number of events processed
    "n_shard": 0,     // the number of chunks the replay job was broken into
    "n_eval": 0,      // the number of operator evaluations performed
    "wall_time": 0    // the number of real-world seconds the job took
  },
  "did_match": false, // indicates if the rule matched any event at all
  "results": [],      // a list of dictionaries containing the details of actions the engine would have taken
  "traces": []        // a list of trace items to help you troubleshoot where a rule failed
}
```

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
https://0651b4f82df0a29c.replay.limacharlie.io/
```

To query Replay, do a `POST` with a `Content-Type` header of `application-json` and with a JSON body like:

```json
{
  "oid": "",             // OID this query relates to
  "rule_source": {       // rule source information (use one of "rule_name" or "rule")
    "rule_name": "",     // pre-existing rule name to run
    "rule": {            // literal rule to run
      "detect": {},
      "respond": []
    }
  },
  "event_source": {      // event source information (use one of "sensor_events" or "events")
    "sensor_events": {   // use historical events from sensors
      "sid": "",         // sensor id to replay from, or entire org if empty
      "start_time": 0,   // start second epoch time to replay from
      "end_time": 0      // end second epoch time to replay to
    },
    "events": [{}]       // literal list of events to replay
  },
  "limit_event": 0,      // optional approximate number of events to process
  "limit_eval": 0,       // optional approximate number of operator evaluations to perform
  "trace": false         // optional, if true add trace information to response, VERY VERBOSE
}
```

## Billing
The Replay service is billed on a per operator evaluation basis.

A [D&R Rule](dr.md) is composed of multiple operator evaluations. It is each of those evaluations that gets
billed for the Replay service. It means that generally speak the number of operator evaluations will be based
on the `number of events replayed X complexity of the rule`.

Rules, especially complex ones can be hard to evaluate since rules will often perform evaluation short-cicruits
to reduce the number of evaluations in certain cases. Therefore the best way to evaluate a rule is to use the
[LimaCharlie CLI](https://github.com/refractionPOINT/python-limacharlie/) with the `limacharlie replay` command
which outputs precise statistics about a Replay job. This will include number of operator evaluations which will
then help you determine the performance of your rule.
