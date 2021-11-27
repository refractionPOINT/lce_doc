# Reference: Destinations

## General Parameters

All Destinations can be configured with the following options: 

* `is_flat`: take the json output and flatten the whole thing to a flat structure.
* `inv_id`: only send events matching the investigation id to this output (event stream only).
* `tag`: only send events from sensors with this tag to this output (event stream only).
* `cat`: only send detections from this category to this output (detect stream only).
* `cat_black_list`: only send detections that do not match the prefixes in this list (newline-separated).
* `event_white_list`: only send event of the types in this list (newline-separated, event and audit streams only).
* `event_black_list`: only send event not of the types in this list (newline-separated, event and audit streams only).
* `is_delete_on_failure`: if an error occurs during output, delete the output automatically.
* `is_prefix_data`: wrap JSON events in a dictionary with the event_type as the key and original event as value.

> Need support for a Destination we haven't integrated yet? Let us know by chiming in on the [LimaCharlie community Slack](https://slack.limacharlie.io/), or by emailing us at [`support@limacharlie.io`](mailto:support@limacharlie.io).

## Amazon S3
Output events and detections to an Amazon S3 bucket.

* `bucket`: the path to the AWS S3 bucket.
* `key_id`:  the id of the AWS auth key.
* `secret_key`: the AWS secret key to auth with.
* `sec_per_file`: the number of seconds after which a file is cut and uploaded.
* `is_compression`: if set to "true", data will be gzipped before upload.
* `is_indexing`: if set to "true", data is uploaded in a way that makes it searchable.
* `region_name`: optionally specify a region name.
* `endpoint_url`: optionally specify a custom endpoint URL, usually used with region_name to output to S3-compatible 3rd party services.
* `dir`: the directory prefix

Example:
```yaml
bucket: my-bucket-name
key_id: AKIAABCDEHPUXHHHHSSQ
secret_key: fonsjifnidn8anf4fh74y3yr34gf3hrhgh8er
is_indexing: "true"
is_compression: "true"
```

If you have your own visualization stack, or you just need the data archived, you can upload
directly to Amazon S3. This way you don't need any infrastructure.

If the `is_indexing` option is enabled, data uploaded to S3 will be in a specific format enabling some indexed queries.
LC data files begin with a `d` while special manifest files (indicating
which data files contain which sensors' data) begin with an `m`. Otherwise (not `is_indexing`) data is uploaded
as flat files with a UUID name.

The `is_compression` flag, if on, will compress each file as GZIP when uploaded.

It is recommended you enable `is_compression`.

1. Log in to AWS console and go to the IAM service.
1. Click on "Users" from the menu.
1. Click "Add User", give it a name and select "Programmatic access".
1. Click "Next permissions", then "Next review", you will see a warning about no access, ignore it and click "Create User".
1. Take note of the "Access key", "Secret access key" and ARN name for the user (starts with "arn:").
1. Go to the S3 service.
1. Click "Create Bucket", enter a name and select a region.
1. Click "Next" until you get to the permissions page.
1. Select "Bucket policy" and input the policy in [sample below](#policy-sample):
    where you replace the "<<USER_ARN>>" with the ARN name of the user you created and the "<<BUCKET_NAME>>" with the
    name of the bucket you just created.
1. Click "Save".
1. Click the "Permissions" tab for your bucket.
1. Back in limacharlie.io, in your organization view, create a new Output.
1. Give it a name, select the "s3" module and select the stream you would like to send.
1. Enter the bucket name, key_id and secret_key you noted down from AWS.
1. Click "Create".
1. After a minute, the data should start getting written to your bucket.

#### Policy Sample

```json
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "PermissionForObjectOperations",
         "Effect": "Allow",
         "Principal": {
            "AWS": "<<USER_ARN>>"
         },
         "Action": "s3:PutObject",
         "Resource": "arn:aws:s3:::<<BUCKET_NAME>>/*"
      }
   ]
}
```

## Google Cloud Pubsub
Output events and detections to a Pubsub topic.

* `secret_key`: the secret json key identifying a service account.
* `project`: the GCP Project name where the Topic lives.
* `topic`: use this specific value as a topic.

Example:
```yaml
project: my-project
topic: telemetry
secret_key: {
  "type": "service_account",
  "project_id": "my-lc-data",
  "private_key_id": "11b6f4173dedabcdefb779e4afae6d88ddce3cc1",
  "private_key": "-----BEGIN PRIVATE KEY-----\n.....\n-----END PRIVATE KEY-----\n",
  "client_email": "my-service-writer@my-lc-data.iam.gserviceaccount.com",
  "client_id": "102526666608388828174",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my-service-writer%40my-lc-data.iam.gserviceaccount.com"
}
```

## Google Cloud Storage
Output events and detections to a GCS bucket.

* `bucket`: the path to the GCS bucket.
* `secret_key`: the secret json key identifying a service account.
* `sec_per_file`: the number of seconds after which a file is cut and uploaded.
* `is_compression`: if set to "true", data will be gzipped before upload.
* `is_indexing`: if set to "true", data is uploaded in a way that makes it searchable.
* `dir`: the directory prefix where to output the files on the remote host.

Example:
```yaml
bucket: my-bucket-name
secret_key: {
  "type": "service_account",
  "project_id": "my-lc-data",
  "private_key_id": "11b6f4173dedabcdefb779e4afae6d88ddce3cc1",
  "private_key": "-----BEGIN PRIVATE KEY-----\n.....\n-----END PRIVATE KEY-----\n",
  "client_email": "my-service-writer@my-lc-data.iam.gserviceaccount.com",
  "client_id": "102526666608388828174",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my-service-writer%40my-lc-data.iam.gserviceaccount.com"
}
is_indexing: "true"
is_compression: "true"
```

If the `is_indexing` option is enabled, data uploaded to GCS will be in a specific format enabling some indexed queries. LC data files begin with a `d` while special manifest files (indicating which data files contain which sensors' data) begin with an `m`. Otherwise (not `is_indexing`) data is uploaded as flat files with a UUID name.

The `is_compression` flag, if on, will compress each file as GZIP when uploaded.

It is recommended you enable `is_indexing` and `is_compression`.

1. Go to the [IAM Service Account console](https://console.cloud.google.com/iam-admin/serviceaccounts).
1. Click "Create Service Account", give it a name, no role, check the "Furnish a new private key".
1. The private key will download to your computer, this is the file containing the key you will later set as `secret_key` in the GCS Output.
1. Go to the [Google Cloud Storage console](https://console.cloud.google.com/storage).
1. Create a new bucket in whatever region you prefer.
1. In your new bucket, click "Permissions", then "Add member".
1. Enter the name of the Service Account you created above.
1. As a role, select "Storage" --> "Storage Object Creator" and "Storage Legacy Bucket Writer" (this will grant Write-Only access to this account).
1. Back in limacharlie.io, in your organization view, create a new Output.
1. Give it a name, select the "gcs" module and select the stream you would like to send.
1. Enter the bucket name and secret_key (contents of the file automatically downloaded when you created the Service Account).
1. Click "Create".
1. After a minute, the data should start getting written to your bucket.

Now this has created a single Service Account in Write-Only mode.

## Humio
Output events and detections to the [Humio.com](https://humio.com) service.

* `humio_repo`: the name of the humio repo to upload to.
* `humio_api_token`: the humio ingestion token.
* `endpoint_url`: optionally specify a custom endpoint URL, if you have Humio deployed on-prem use this to point to it, otherwise it defaults to the Humio cloud.

Example:
```yaml
humio_repo: sandbox
humio_api_token: fdkoefj0erigjre8iANUDBFyfjfoerjfi9erge
```

Note: You may need to [create a new parser in Humio](https://docs.humio.com/docs/parsers/creating-a-parser/) to correctly [parse timestamps](https://docs.humio.com/reference/query-functions/functions/parsetimestamp/).  You can use the following JSON parser:
```
parseJson() | parseTimestamp(field=@timestamp,format="unixTimeMillis",timezone="Etc/UTC")
```

## Kafka
Output events and detections to a Kafka target.

* `dest_host`: the IP or DNS and port to connect to, format `kafka.myorg.com`.
* `is_tls`: if `true` will output over TCP/TLS.
* `is_strict_tls`: if `true` will enforce validation of TLS certs.
* `username`: if specified along with `password`, use for Basic authentication.
* `password`: if specified along with `username`, use for Basic authentication.
* `routing_topic`: use the element with this name from the `routing` of the event as the Kafka topic name.
* `literal_topic`: use this specific value as a topic.

Example:
```yaml
dest_host: kafka.corp.com
is_tls: "true"
is_strict_tls: "true"
username: lc
password: letmein
literal_topic: telemetry
```

## SCP
Output events and detections over SCP (SSH file transfer).

* `dest_host`: the ip:port where to send the data to, like `1.2.3.4:22`.
* `dir`: the directory where to output the files on the remote host.
* `username`: the SSH username to log in with.
* `password`: optional password to use to login with.
* `secret_key`: the optional SSH private key to authenticate with.

Example:
```yaml
dest_host: storage.corp.com
dir: /uploads/
username: storage_user
password: XXXXXXXXXXXX
```

## SFTP
Output events and detections over SFTP.

* `dest_host`: the ip:port where to send the data to, like `1.2.3.4:22`.
* `dir`: the directory where to output the files on the remote host.
* `username`: the username to log in with.
* `password`: optional password to use to login with.
* `secret_key`: the optional SSH private key to authenticate with.

Example:
```yaml
dest_host: storage.corp.com
dir: /uploads/
username: storage_user
password: XXXXXXXXXXXX
```

## Slack
Output detections and audit (only) to a Slack community and channel.

* `slack_api_token`: the Slack provided API token used to authenticate.
* `slack_channel`: the channel to output to within the community.

Example:
```yaml
slack_api_token: d8vyd8yeugr387y8wgf8evfb
slack_channel: #detections
```

## Provisioning
To use this Output, you need to create a Slack App and Bot. This is very simple:
1. Head over to https://api.slack.com/apps
1. Click on "Create App" and select the workspace where it should go
1. From the sidebar, click on OAuth & Permissions
1. Go to the section "Bot Token Scope" and click "Add an OAuth Scope"
1. Select the scope `chat:write`
1. From the sidebar, click "Install App" and then "Install to Workspace"
1. Copy token shown, this is the `slack_api_token` you need in LimaCharlie
1. In your Slack workspace, go to the channel you want to receive messages in, and type the slash command: `/invite @limacharlie` (assuming the app name is `limacharlie`)

## SMTP
Output individually each event, detection, audit, deployment or log through an email.

* `dest_host`: the IP or DNS (and optionally port) of the SMTP server to use to send the email.
* `dest_email`: the email address to send the email to.
* `from_email`: the email address to set in the From field of the email sent.
* `username`: the username (if any) to authenticate with the SMTP server with.
* `password`: the password (if any) to authenticate with the SMTP server with.
* `secret_key`: an arbitrary shared secret used to compute an HMAC (SHA256) signature of the email to verify authenticity. This is a required field. See "Webhook Details" section below.
* `is_readable`: if 'true' the email format will be HTML and designed to be readable by a human instead of a machine.
* `is_starttls`: if 'true', use the Start TLS method of securing the connection instead of pure SSL.
* `is_authlogin`: if 'true', authenticate using `AUTH LOGIN` instead of `AUTH PLAIN`.
* `subject`: is specified, use this as the alternate "subject" line.

Example:
```yaml
dest_host: smtp.gmail.com
dest_email: soc@corp.com
from_email: lc@corp.com
username: lc
password: password-for-my-lc-email-user
secret_key: this-is-my-secret-shared-key
```

## Syslog (TCP)
Output events and detections to a syslog target.

* `dest_host`: the IP or DNS and port to connect to, format `www.myorg.com:514`.
* `is_tls`: if `true` will output over TCP/TLS.
* `is_strict_tls`: if `true` will enforce validation of TLS certs.
* `is_no_header`: if `true` will not emit a Syslog header before every message. This effectively turns it into a TCP output.
* `structured_data`: arbitrary field to include in syslog "Structured Data" headers. Sometimes useful for cloud SIEMs integration.

Example:
```yaml
dest_host: storage.corp.com
is_tls: "true"
is_strict_tls: "true"
is_no_header: "false"
```

## Webhook
Output individually each event, detection, audit, deployment or artifact through a POST webhook.

* `dest_host`: the IP or DNS, port and page to HTTP(S) POST to, format `https://www.myorg.com:514/whatever`.
* `secret_key`: an arbitrary shared secret used to compute an HMAC (SHA256) signature of the webhook to verify authenticity. See "Webhook Details" section below.
* `auth_header_name` and `auth_header_value`: set a specific value to a specific HTTP header name in the outgoing webhooks.

Example:
```yaml
dest_host: https://webhooks.corp.com/new_detection
secret_key: this-is-my-secret-shared-key
auth_header_name: x-my-special-auth
auth_header_value: 4756345846583498
```

## Webhook Bulk
Output batches of events, detections, audits, deployments or artifacts through a POST webhook.

* `dest_host`: the IP or DNS, port and page to HTTP(S) POST to, format `https://www.myorg.com:514/whatever`.
* `secret_key`: an arbitrary shared secret used to compute an HMAC (SHA256) signature of the webhook to verify authenticity. This is a required field. See "Webhook Details" section below.
* `auth_header_name` and `auth_header_value`: set a specific value to a specific HTTP header name in the outgoing webhooks.
* `sec_per_file`: the number of seconds after which a file is cut and uploaded.


Example:
```yaml
dest_host: https://webhooks.corp.com/new_detection
secret_key: this-is-my-secret-shared-key
auth_header_name: x-my-special-auth
auth_header_value: 4756345846583498
```
