# Secrets

LimaCharlie supports decoupling the value of secrets from their usage in various configurations.

The most common usage is for storing the secret keys used by various [Outputs](outputs.md). This allows
you to grant permissions to some users to see the configuration of an Output, but not have access to
the credentials it uses.

This is achieved by storing secrets in a [Hive](hive.md) called `secret`, which its own sets of permissions.

A secret record in hive has a very basic format:
```json
{
    "secret": "your-secret-value-here"
}
```
The `data` portion of the records in this hive must have a single key called `secret` who's value is the value
that will be used by various LimaCharlie components.

## Permissions
The `secret` hive requires the following permissions for the various operations:

* `secret.get`
* `secret.set`
* `secret.del`
* `secret.get.mtd`
* `secret.set.mtd`


## Usage and Examples

### Outputs
Using a secret in combination with an Output has very few steps:
1. Create a secret in the `secret` hive.
1. Create an Output and use the format `hive://secret/my-secret-name` as the value for a credentials field.

For example, let's create a simple secret using the LimaCharlie CLI in a terminal:
```bash
# Set the secret in hive from the stdin using the CLI.
echo '{"secret": "my-secret-value"}' | limacharlie hive set secret --key my-secret --data -

# You should get a confirmation the secret was created like:
# {
#   "guid": "3a7a2865-a439-4d1a-8f50-b9a6d833075c",
#   "hive": {
#     "name": "secret",
#     "partition": "8cbe27f4-aaaa-bbbb-cccc-138cd51389cd"
#   },
#   "name": "my-secret"
# }

# You can confirm the secret is present if you'd like:
# limacharlie hive get secret --key my-secret
# {
#   "data": {
#     "secret": "my-secret-value"
#   },
#   "usr_mtd": {
#     "expiry": 0,
#     "enabled": false,
#     "tags": null
#   },
#   "sys_mtd": {
#     "etag": "f7e237b5d899c5bccb66fb30e78f17d9",
#     "created_at": 1673026955364,
#     "created_by": "lc-example",
#     "guid": "3a7a2865-a439-4d1a-8f50-b9a6d833075c",
#     "last_author": "lc-example",
#     "last_mod": 1673026955364,
#     "last_error": "",
#     "last_error_ts": 0
#   }
# }

# Next, create an Output in the web app (https://app.limacharlie.io)
# Let's say a BigQuery Output, and use the value "hive://secret/my-secret" as
# the "Secret Key" value.

# That's it, the Output should start as expected, but viewing the Output's
# configuration should only show the reference to the secret "hive://secret/my-secret"
# instead of the actual API Key / Password / Service Account creds.
```