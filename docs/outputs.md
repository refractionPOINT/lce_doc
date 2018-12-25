# Output Modules

[TOC]

## Configurations

**General Parameters**
* `is_flat`: take the json output and flatten the whole thing to a flat structure.
* `inv_id`: only send events matching the investigation id to this output (event stream only).
* `tag`: only send events from sensors with this tag to this output (event stream only).
* `cat`: only send detections from this category to this output (detect stream only).
* `event_white_list`: only send event of the types in this list (newline-seperated).
* `event_black_list`: only send event not of the types in this list (newline-seperated).

### Amazon S3
Output events and detections to an Amazon S3 bucket.

* `bucket`: the path to the AWS S3 bucket.
* `key_id`:  the id of the AWS auth key.
* `secret_key`: the AWS secret key to auth with.
* `sec_per_file`: the number of seconds after which a file is cut and uploaded.
* `is_compression`: if set to "true", data will be gzipped before upload.
* `is_indexing`: if set to "true", data is uploaded in a way that makes it searchable.
* `region_name`: optionally specify a region name.
* `endpoint_url`: optionally specify a custom endpoint URL, usually used with region_name to output to S3-compatible 3rd party services.

Example:
```
bucket: my-bucket-name
key_id: AKIAABCDEHPUXHHHHSSQ
secret_key: fonsjifnidn8anf4fh74y3yr34gf3hrhgh8er
is_indexing: "true"
is_compression: "true"
```

### Google Cloud Storage
Output events and detections to a GCS bucket.

* `bucket`: the path to the AWS S3 bucket.
* `secret_key`: the secret json key identifying a service account.
* `sec_per_file`: the number of seconds after which a file is cut and uploaded.
* `is_compression`: if set to "true", data will be gzipped before upload.
* `is_indexing`: if set to "true", data is uploaded in a way that makes it searchable.

Example:
```
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

### SCP
Output events and detections over SCP (SSH file transfer).

* `dest_host`: the ip:port where to send the data to, like `1.2.3.4:22`.
* `dir`: the directory where to output the files on the remote host.
* `username`: the SSH username to log in with.
* `password`: optional password to use to login with.
* `secret_key`: the optional SSH private key to authenticate with.

Example:
```
dest_host: storage.corp.com
dir: /uploads/
username: storage_user
password: XXXXXXXXXXXX
```

### SFTP
Output events and detections over SFTP.

* `dest_host`: the ip:port where to send the data to, like `1.2.3.4:22`.
* `dir`: the directory where to output the files on the remote host.
* `username`: the username to log in with.
* `password`: optional password to use to login with.
* `secret_key`: the optional SSH private key to authenticate with.

Example:
```
dest_host: storage.corp.com
dir: /uploads/
username: storage_user
password: XXXXXXXXXXXX
```

### Slack
Output detections and audit (only) to a Slack community and channel.

* `slack_api_token`: the Slack provided API token used to authenticate.
* `slack_channel`: the channel to output to in the community.

Example:
```
slack_api_token: d8vyd8yeugr387y8wgf8evfb
slack_channe: #detections
```

### Syslog (TCP)
Output events and detections to a syslog target.

* `dest_host`: the IP or DNS and port to connect to, format `www.myorg.com:514`.
* `is_tls`: if `true` will output over TCP/TLS.
* `is_strict_tls`: if `true` will enforce validation of TLS certs.
* `is_no_header`: if `true` will not emit a Syslog header before every message. This effectively turns it into a TCP output.
* `structured_data`: arbitrary field to include in syslog "Structured Data" headers. Sometimes useful for cloud SIEMs integration.

Example:
```
dest_host: storage.corp.com
is_tls: "true"
is_strict_tls: "true"
is_no_header: "false"
```

### Webhook
Output individually each event, detection or audit through a POST webhook.

* `dest_host`: the IP or DNS, port and page to HTTP(S) POST to, format `https://www.myorg.com:514/whatever`.
* `secret_key`: an arbitrary shared secret used to compute an HMAC (SHA256) signature of the webhook to verify authenticity. See "Webhook" section below.

Example:
```
dest_host: https://webhooks.corp.com/new_detection
secret_key: this-is-my-secret-shared-key
```

### SMTP
Output individually each event, detection or audit through an email.

* `dest_host`: the IP or DNS (and optionally port) of the SMTP server to use to send the email.
* `dest_email`: the email address to send the email to.
* `from_email`: the email address to set in the From field of the email sent.
* `username`: the username (if any) to authenticate with the SMTP server with.
* `password`: the password (if any) to authenticate with the SMTP server with.
* `secret_key`: an arbitrary shared secret used to compute an HMAC (SHA256) signature of the email to verify authenticity. See "Webhook" section below.
* `is_readable`:if 'true' the email format will be HTML and designed to be readable by a human instead of a machine.

Example:
```
dest_host: smtp.gmail.com
dest_email: soc@corp.com
from_email: lc@corp.com
username: lc
password: password-for-my-lc-email-user
secret_key: this-is-my-secret-shared-key
```

### Humio
Output events and detections to the Humio.com service.

* `humio_repo`: the name of the humio repo to upload to.
* `humio_api_token`: the humio ingestion token.

Example:
```
humio_repo: sandbox
humio_api_token: fdkoefj0erigjre8iANUDBFyfjfoerjfi9erge
```

## Integrations

### Common Patterns
Here are a few common topologies used with LimaCharlie Cloud (LCC).

All data over batched files via SFTP, Splunk or ELK consumes the received files for ingestion.
```
Sensor ---> LCC (All Streams) ---> SFTP ---> ( Splunk | ELK )
```

All data stramed in real-time via Syslog, Splunk or ELK receive directly via an open Syslog socket.
```
Sensor ---> LCC (All Streams) ---> Syslog( TCP+SSL) ---> ( Splunk | ELK )
```

All data over batched files stored on Amazon S3, Splunk or ELK consumes the received files remotely for ingestion.
```
Sensor ---> LCC (All Streams) ---> Amazon S3 ---> ( Splunk | ELK )
```

Bulk events are uploaded to Amazon S3 for archival while alerts and auditing events are sent in real-time to Splunk via Syslog.
This has the added benefit of reducing Splunk license cost while keeping the raw events available for analysis at a cheaper cost.
```
Sensor ---> LCC (Event Stream) ---> Amazon S3
       +--> LCC (Alert+Audit Streams) ---> Syslog (TCP+SSL) ---> Splunk
```

### Splunk
Splunk provides you with a simple web interface to view and search the data.
It has a paying enterprise version and a free tier.

Below are manual steps to using Splunk with LimaCharlie data. But you can also use
this [installation script](install_simple_splunk.sh) to install and configure a free
version on a Debian/Ubuntu server automatically.

Because the LimaCharlie.io cloud needs to be able to reach your Splunk instance at all times to upload data, we recommend
you create a virtual machine at a cloud provider like DigitalOcean, Amazon AWS or Google Cloud.

Splunk is the visualization tool, but there are many ways you can use to get the data to Splunk. We will use SFTP as it
is fairly simple and safe.

1. Create your virtual machine, for example using [this DigitalOcean tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-your-first-digitalocean-droplet).
1. Install Splunk, [here](https://medium.com/@smurf3r5/splunk-enterprise-on-digital-ocean-ubuntu-16-x-95c31c7e7e2c) is a quick tutotial on how to do that.
1. Configure a write-only user and directory for SFTP using [this guide](https://www.digitalocean.com/community/tutorials/how-to-enable-sftp-without-shell-access-on-ubuntu-16-04).
  1. We recommend using `PasswordAuthentication false` and to use RSA keys instead, but for ease you may simply set a password.
1. Edit the file `/opt/splunk/etc/apps/search/local/props.conf` and add the following lines:
    ```
    [limacharlie]
    SHOULD_LINEMERGE = false
    ```
1. Edit the file `/opt/splunk/etc/apps/search/local/inputs.conf` and add the following lines:
    ```
    [batch:///var/sftp/uploads]
    disabled = false
    sourcetype = limacharlie
    move_policy = sinkhole
    ```
1. Restart Splunk by issuing: `sudo /opt/splunk/bin/splunk restart`.
1. Back in limacharlie.io, in your organization view, create a new Output.
1. Git it a name, select the "sftp" module and select the stram you would like to send.
1. Set the "username" that you used to setup the SFTP service.
1. Set either the "password" field or the "secret_key" field depending on which one you chose when setting up SFTP.
1. In "dest_host", input the public IP address of the virtual machine you created.
1. Set the "dir" value to "/uploads/".
1. Click "Create".
1. After a minute, the data should start getting written to the `/var/sftp/uploads` directory on the server and Splunk should ingest it.
1. In Splunk, doing a query for "sourcetype=limacharlie" should result in your data.

If you are using the free version of Splunk, note that user management is not included. The suggested method to make
access to your virtual machine safe is to use an SSH tunnel. This will turn a local port into the remote Splunk port
over a secure connection. A sample SSH tunnel command looks like this:
```
ssh root@your-splunk-machine -L 127.0.0.1:8000:0.0.0.0:8000 -N
```
Then you can connect through the tunnel with your browser at `http://127.0.0.1:8000/`.

### Amazon S3
If you have your own visualization stack, or you just need the data archived, you can upload
directly to Amazon S3. This way you don't need any infrastructure.

If the `is_indexing` option is enabled, data uploaded to S3 will be in a specific format enabling the
live querying by the Digger web app. LC data files begin with a `d` while special manifest files (indicating
which data files contain which sensors' data) begin with an `m`. Otherwise (not `is_indexing`) data is uploaded
as flat files with a UUID name.

The `is_compression` flag, if on, will compress each file as GZIP when uploaded. The files being compressed does NOT prevent
the Digger web app from accessing them (it decompresses them on the fly) but it may prevent other tools expecteding plain
text from reading the files.

It is recommended you enable `is_indexing` and `is_compression`.

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
1. Select CORS Configuration
1. In the editor, enter the configuration you find below, this allows the Digger to access the data through the browser.
1. Back in limacharlie.io, in your organization view, create a new Output.
1. Give it a name, select the "s3" module and select the stream you would like to send.
1. Enter the bucket name, key_id and secret_key you noted down from AWS.
1. Click "Create".
1. After a minute, the data should start getting written to your bucket.

#### Policy Sample
This policy example also shows two more statements (the bottom two) that are the permissions required for a user that
is Read-Only to be used in the Digger configuration. We recommend using a Write-Only user from LC and a Read-Only user
from Digger.

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
      },
      {
         "Sid": "PermissionForObjectOperations",
         "Effect": "Allow",
         "Principal": {
             "AWS": "<<DIGGER_READER_USER_ARN>>"
         },
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::<<BUCKET_NAME>>/*"
      },
      {
        "Sid": "PermissionForObjectOperations",
        "Effect": "Allow",
        "Principal": {
            "AWS": "<<DIGGER_READER_USER_ARN>>"
        },
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::<<BUCKET_NAME>>"
      }
   ]
}
```

#### CORS Configuration
```xml
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
<CORSRule>
    <AllowedOrigin>*</AllowedOrigin>
    <AllowedMethod>HEAD</AllowedMethod>
    <AllowedMethod>GET</AllowedMethod>
    <AllowedHeader>*</AllowedHeader>
</CORSRule>
</CORSConfiguration>

```

### Google Cloud Storage

***Google Cloud Storage is currently only supported as an Output. Visualization of data in Digger from GCS is not yet possible.***

If you have your own visualization stack, or you just need the data archived, you can upload
directly to Google Cloud Storage (GCS). This way you don't need any infrastructure.

If the `is_indexing` option is enabled, data uploaded to GCS will be in a specific format enabling the
live querying by the Digger web app. LC data files begin with a `d` while special manifest files (indicating
which data files contain which sensors' data) begin with an `m`. Otherwise (not `is_indexing`) data is uploaded
as flat files with a UUID name.

The `is_compression` flag, if on, will compress each file as GZIP when uploaded. The files being compressed does NOT prevent
the Digger web app from accessing them (it decompresses them on the fly) but it may prevent other tools expecteding plain
text from reading the files.

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

Now this has create a single Service Account in Write-Only mode. To access your data in Digger, you will want to do the same
steps as above, creating a new Service Account. This time however, you will set the "Storage" --> "Storage Object Viewer". The
Service Account downloaded will be used in the Digger.

### HTTP Streaming
It is also possible to stream an output over HTTPS. This interface allows you to stream smaller dataset
like investigations or specific sensors or detections. This stream can be achieved via HTTP only without
any additional software layer, although the [Python API](https://github.com/refractionpoint/python-limacharlie/) makes
this task easier using the Spout object.

This feature is activated in two steps.

Step 1. Signal that you would like to begin streaming data over HTTPS. This is done by issuing an HTTP POST to
`https://output.limacharlie.io/output/<OID>` where `<OID>` is the organization ID you would like to stream from. As
additional data in the POST, specify the following parameters:
* `api_key`: this is the secret API key as provided to you in limacharlie.io.
* `type`: this is the stream type you would like to create, one of `event`, `detect` or `audit`.
* `cat`: optional, specifies the detection type to filter on.
* `tag`: optional, specifies the sensor tags to filter on.
* `inv_id`: optional, specifies the investigation ID to filter on.

The response from this POST will be an `HTTP 303 See Other`, a redirect. This redirect will point you to where the data
stream will be available.

Note that once you receive the redirect, a new temporary Output will also show up in your organization.

Step 2. Now simply do an HTTP GET to the URL pointed to you in the redirect response. Data will begin streaming shortly.
The format of this data will be newline-seperated JSON much like all other Outputs.

Do note that if you want, you can keep track of this URL you've been redirected to. If your connection is to drop for
whatever reason, or you would like to shard the stream over multiple connections, you can simply re-issue this GET for up to
10 minutes after your last disconnection. After 10 minutes without any clients connected, the Output will be torn down and
you will have to re-issue a POST (step 1) to begin streaming again.

Also note that this method of getting data requires you to have a fast enough connection to receive the data as the buffering
done on the side of `output.limacharlie.io` is very minimal. If you are not fast enough, data will be dropped and you will
be notified of this by special events in the stream like this: `{"__trace":"dropped", "n":5}` where `n` is the number of
that were dropped. If no data is present in the stream (like rare detections), you will also receive a `{"__trace":"keepalive"}`
message aproximately every minute to indicate the stream is still alive.

### Webhook
Using this ouput, every element will be sent over HTTP(S) to a webserver of your choice via a POST.

The JSON data will be found in the `data` parameter of the `application/x-www-form-urlencoded` encoded POST.

An HTTP header name `Lc-Signature` will contain an HMAC signature of the contents. This HMAC is computed from the string
value of the `data` parameter and the `secret_key` set when creating the Output, using SHA256 as the hashing algorithm.

The validity of the signature can be checked manually or using the `Webhook` objects of the [Python API](https://github.com/refractionpoint/python-limacharlie/) or
the [JavaScript API](https://www.npmjs.com/package/limacharlie).

For example, here is a sample Google Cloud Function that can receive a webhook:
```javascript
const Webhook = require('limacharlie/Webhook');

/**
 * Receives LimaCharlie.io webhooks.
 *
 * @param {!Object} req Cloud Function request context.
 * @param {!Object} res Cloud Function response context.
 */
exports.lc_cloud_func = (req, res) => {
  // Example input: {"message": "Hello!"}
  if (req.body.data === undefined) {
    // This is an error case, as we expect a form parameter "data".
    console.error('Got: ' + JSON.stringify(req.body, null, 2));
    res.status(400).send('No data defined.');
  } else {
    // First thing to do is validate this is a legitimate
    // webhook sent by limacharlie.io.
    let hookData = req.body.data;

    // This is the secret key set when creating the webhook.
    let whSecretKey = '123';

    // This is the signature sent via header, we must validate it.
    let whSignature = req.get('Lc-Signature');

    // This object will do the validation for you.
    let wh = new Webhook(whSecretKey);

    // Check the signature and return early if not valid.
    if(!wh.isSignatureValid(hookData, whSignature)) {
    console.error("Invalid signature, do not trust!");
      // Early return, 200 or an actual error if you want.
      res.status(200);
    }

    console.log("Good signature, proceed.");

    // Parse the JSON payload.
    hookData = JSON.parse(hookData);
    console.log("Parsed hook data: " + JSON.stringify(hookData, null, 2));

    // This is where you would do your own processing
    // like talking to other APIs etc.

    res.status(200);
  }
};

```

### Security Onion
A great guide for integrating LimaCharlie into [Security Onion](https://securityonion.net/) is
available [here](https://medium.com/@wlambertts/security-onion-limacharlie-befe5e8e91fa) along
with the code [here](https://github.com/weslambert/securityonion-limacharlie/).