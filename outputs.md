# Output Modules

## Configurations

**General Parameters**
* `is_flat`: take the json output and flatten the whole thing to a flat structure.
* `is_base64`: instead of escaping binary data to hex, escape it to base64.
* `is_full_tag`: display the fully qualified tag name instead of the short version.

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
* `secret_key`: the SSH private key to authenticate with.

### Slack
Output detections (only) to a Slack community and channel.

* `slack_api_token`: the Slack provided API token used to authenticate.
* `slack_channel`: the channel to output to in the community.

### Syslog
Output events and detections to a syslog target.

* `dest_host`: the IP or DNS and port to connect to, format `www.myorg.com:514`.
* `is_tls`: if `true` will output over TCP/TLS.

## Integrations

* [Splunk](splunk.md)
