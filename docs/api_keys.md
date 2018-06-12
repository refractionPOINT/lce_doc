# API Keys

[TOC]

LimaCharlie Cloud has a concept of API keys. Those are secret keys that can be created and named which can then in turn
be used to retrieve a JWT that can be used with the LC REST Api at https://api.limacharlie.io.

This allows you to build headless applications that securely acquire time-restricted REST authentication tokens that it
can then use.

## Managing
The API Keys are managed through the organization view of the https://limacharlie.io web interface.

## Getting a JWT
Simply issue an HTTP GET like:
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

General modifier:
* Read: can read configuration values.
* Write: can update and create configuration values.

Scopes:
* Execute: can execute tasks on agents *(does not require any general modifier to work)*.
* Installation Keys: can deal with Installation Keys.
* D&R Rules: can deal with D&R Rules.
* Output: can deal with Outputs.

This means that a key with *Read* and *Output* will be able to read all Outputs currently configured, but will not be able 
to create any new Outputs.

For example, the Spout feature from the [Python](https://github.com/refractionpoint/python-limacharlie/) and [JS](https://www.npmjs.com/package/limacharlie) API (streaming Output over HTTPS) requires *Read*, *Write* and *Output* 
privileges.
