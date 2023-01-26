# Webhook Ingestion

LimaCharlie supports webhooks as an ingestion method.

This feature is technically a [Cloud Adapter](lc_adapter.md), but given it's nature, it is only available
in the cloud adapter form and not through adapter downloadable binary.

By enabling a webhook through the `cloud_sensor` [Hive](hive.md), you will open up a specific URL to which
you can send webhooks from other platforms. The data received there will make its way into LimaCharlie as
a sensor in the same way an Office365 or Syslog Adapter would do.

## Webhook Config Format
A webhook configuration record looks like:
```json
{
    "sensor_type": "webhook",
    "webhook": {
        // This secret value will be part of the URL to accept your webhooks.
        // It enables you to prevent or revoke unauthorized access to a hook.
        "secret": "some-secret-value-hard-to-predict",

        // Placeholder for generic webhook signature validation.
        // If you require a specific format, please get in touch with us.
        "signature_secret": "",
        "signature_header": "",
        "signature_scheme": "",

        // Format with which the data is ingested in LC.
        "client_options": {
            "hostname": "test-webhook",
            "identity": {
                "oid": "8cbe27f4-aaaa-aaaa-aaaa-138cd51389cd",
                "installation_key": "787ad9ee-aaaa-aaaa-aaaa-63fbf40b1c2e"
            },
            "platform": "json",
            "sensor_seed_key": "test-webhook"
        }
    }
}
```

### Creating
You can create a webhook either through the webapp, or through the API, or CLI.

Here's a simple example of creating the above record through a CLI:
```bash
echo '{"sensor_type": "webhook", "webhook": {"secret": "some-secret-value-hard-to-predict", "signature_secret": "", "signature_header": "", "signature_scheme": "", "client_options": {"hostname": "test-webhook", "identity": {"oid": "8cbe27f4-aaaa-aaaa-aaaa-138cd51389cd", "installation_key": "787ad9ee-aaaa-aaaa-aaaa-63fbf40b1c2e"}, "platform": "json", "sensor_seed_key": "test-webhook"}}}' | limacharlie hive set cloud_sensor --key my-webhook --data -
```

### Hook URL
The resulting webhook will be accessible via a URL that is dependant on the LimaCharlie
geo where your Org is.

To get the relevant geo-specific domain, you can use:
* REST API: https://api.limacharlie.io/static/swagger/#/Organizations/getOrgURLs
* Python SDK: `python3 -c "import limacharlie; print(limacharlie.Manager().getOrgURLs()['hooks'])"`

Assuming the domain you get looks like `9157798c50af372c.hook.limacharlie.io`, the format of the URL
would be `https://9157798c50af372c.hook.limacharlie.io/OID/HOOKNAME/SECRET`, where:
* `OID` is the Organization ID, in the example above `8cbe27f4-aaaa-aaaa-aaaa-138cd51389cd`.
* `HOOKNAME` is the name of the hook, in the example above `test-webhook`.
* `SECRET` is the secret configured, in the example above `some-secret-value-hard-to-predict`.

Which would give you: `https://9157798c50af372c.hook.limacharlie.io/8cbe27f4-aaaa-aaaa-aaaa-138cd51389cd/test-webhook/some-secret-value-hard-to-predict`

## Supported Webhook Format
When POSTin a webhook to the URL, the body of your request is expected to be either one JSON event, or a list of JSON events.
These are the formats that are supported:
* Simple JSON object like `{"some":"data"}`.
* List of JSON objects like `[{"some":"data"}, {"some":"data"}]`.
* Newline separated JSON objects like:
```json
{"some":"data"}
{"some":"data"}
{"some":"data"}
```
* or one of the above, but also GZIPed.

If you need support for something else, please get in touch with us.

## Sending Data
A few examples of sending data through a few different means:

### Python
```bash
python -c "import requests; print( requests.post( 'https://9157798c50af372c.hook.limacharlie.io/8cbe27f4-aaaa-aaaa-aaaa-138cd51389cd/test-webhook/some-secret-value-hard-to-predict', json = {'some':'data'} ).text)"
```

### CURL
```bash
curl -X POST https://9157798c50af372c.hook.limacharlie.io/8cbe27f4-aaaa-aaaa-aaaa-138cd51389cd/test-webhook/some-secret-value-hard-to-predict -H 'Content-Type: application/json' -d '{"some":"data"}'
```
