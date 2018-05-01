***[Back to documentation root](README.md)***

# Output Modules

* TOC
{:toc}

## Configurations

**General Parameters**
* `is_flat`: take the json output and flatten the whole thing to a flat structure.
* `is_base64`: instead of escaping binary data to hex, escape it to base64.
* `is_full_tag`: display the fully qualified tag name instead of the short version.
* `inv_id`: only send events matching the investigation id to this output (event stream only).
* `tag`: only send events from sensors with this tag to this output (event stream only).
* `cat`: only send detections from this category to this output (detect stream only).

### File
Output events and detections to local files.

* `dir`: the directory where to out the files.
* `max_bytes`: maximum number of bytes in a file before it rotates to a new file.
* `backup_count`: total number of files outputted before they are rotated.

### Amazon S3
Output events and detections to an Amazon S3 bucket.

* `bucket`: the path to the AWS S3 bucket.
* `key_id`:  the id of the AWS auth key.
* `secret_key`: the AWS secret key to auth with.
* `sec_per_file`: the number of seconds after which a file is cut and uploaded.

### SCP
Output events and detections over SCP (SSH file transfer).

* `dest_host`: the ip:port where to send the data to, like `1.2.3.4:22`.
* `dir`: the directory where to output the files on the remote host.
* `username`: the SSH username to log in with.
* `password`: optional password to use to login with.
* `secret_key`: the optional SSH private key to authenticate with.

### SFTP
Output events and detections over SFTP.

* `dest_host`: the ip:port where to send the data to, like `1.2.3.4:22`.
* `dir`: the directory where to output the files on the remote host.
* `username`: the username to log in with.
* `password`: optional password to use to login with.
* `secret_key`: the optional SSH private key to authenticate with.

### Slack
Output detections and audit (only) to a Slack community and channel.

* `slack_api_token`: the Slack provided API token used to authenticate.
* `slack_channel`: the channel to output to in the community.

### Syslog (TCP)
Output events and detections to a syslog target.

* `dest_host`: the IP or DNS and port to connect to, format `www.myorg.com:514`.
* `is_tls`: if `true` will output over TCP/TLS.
* `is_no_header`: if `true` will not emit a Syslog header before every message. This effectively turns it into a TCP output.

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

1. Log in to AWS console and go to the IAM service.
1. Click on "Users" from the menu.
1. Click "Add User", give it a name and select "Programmatic access".
1. Click "Next permissions", then "Next review", you will see a warning about no access, ignore it and click "Create User".
1. Take note of the "Access key", "Secret access key" and ARN name for the user (starts with "arn:").
1. Go to the S3 service.
1. Click "Create Bucket", enter a name and select a region.
1. Click "Next" until you get to the permissions page.
1. Select "Bucket policy" and input the following policy:
    ```
    {
       "Version": "2012-10-17",
       "Statement": [
          {
             "Sid": "PermissionForObjectOperations",
             "Effect": "Allow",
             "Principal": {
                "AWS": "<<USER_ARN>>"
             },
             "Action": [
                "s3:PutObject"
             ],
             "Resource": [
                "arn:aws:s3:::<<BUCKET_NAME>>/*"
             ]
          }
       ]
    }
    ```
    where you replace the "<<USER_ARN>>" with the ARN name of the user you created and the "<<BUCKET_NAME>>" with the
    name of the bucket you just created.
1. Click "Save".
1. Back in limacharlie.io, in your organization view, create a new Output.
1. Give it a name, select the "s3" module and select the stream you would like to send.
1. Enter the bucket name, key_id and secret_key you noted down from AWS.
1. Click "Create".
1. After a minute, the data should start getting written to your bucket.
