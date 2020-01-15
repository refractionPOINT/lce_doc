# API Keys

[TOC]

LimaCharlie Cloud has a concept of API keys. Those are secret keys that can be created and named which can then in turn
be used to retrieve a JWT that can be used with the LC REST Api at https://api.limacharlie.io.

This allows you to build headless applications that securely acquire time-restricted REST authentication tokens that it
can then use.

## Managing
The API Keys are managed through the organization view of the https://limacharlie.io web interface.

## Getting a JWT
Simply issue an HTTP GET or HTTP POST (recommended) like:
```
curl "https://app.limacharlie.io/jwt?oid=c82e5c17-d520-4ef5-a4ac-c454a95d31ca&secret=1b1ae891-4316-4124-b859-556dd92add00"
```
where the `oid` parameter is the organization id as found through the web interface and the `secret` parameter is the API
key to use.

The return value is a simple JSON response with a `jwt` component which is the JWT token. This token is only valid for one
hour to limit the possible damage of a leak and make the deletion of the API keys easier.

## Python
A simple [Python API](https://github.com/refractionpoint/python-limacharlie/) is also
provided that simplifies usage of the REST API by taking care of the API Key -> JWT exchange
as necessary and wraps the functionality into nicer objects.

## Privileges
API Keys have several on-off privileges available.

To see a full list, see the "REST API" section of your organization.

Making a REST call will fail with a `401` if your API Key / token is missing
some privileges and the missing privilege will be specified in the error.

## Required Privileges
Below is a list of privileges required for some common tasks.

### Go Live
When "going Live" through the web UI, the following is required by the user:

* `output.*`: for the creation of the real-time output via HTTP to the browser.
* `sensor.task`: to send the commands (both manually for the console and to populate the various tabs) to the sensor.

## Flair
API Keys may have "flair" as part of the key name. A flair is like a tag surrounded by `[]`. Although it is not required, we
advise to put the flair at the end of the API key name for readability.

For example:
`orchestration-key[bulk]` is a key with a `bulk` flair.

Flairs are used to modify slightly the behavior of an API key or provide some usage hints to various systems in LimaCharlie.

The following flairs are currently supported:

* `bulk`: indicates to the REST API that this key is meant to do a large amount of calls, the API gateway tweaks the API call limits accordingly.
* `lock`: indicates that the resources created or updated by this key should be "locked". This means that the only entity able to update or delete those resources is the key itself (or a new key re-created later on with the same name).
* `secret`: indicates that resources created by this key should only have their content visible to the same key. For example [D&R rules](dr.md) will be listed, but the contents will be opaque. This is useful to protect Intellectual Property.

### Lock
The `lock` flair is useful if you are using a key to specifically manage an aspect of your deployment that relies on things like
precisely defined D&R rules, Exfil Watch rules etc. The key flair ensures someone else does not modify it by mistake.
It does NOT bring privacy (other users with the appropriate permissions will still see those resources, but they will not be able to modify them).