# Webhook Bulk
Output batches of events, detections, audits, deployments or artifacts through a POST webhook. 

**Webhook Bulk Usage**

Webhook Bulk is similar to the S3 output, GCS, or SFTP Outputs in that it sends a batch of newline-separated events instead of sending one event at a time. LimaCharlie accumulates the events for a set time and then sends the accumulated events at once. This avoids creating too much traffic and therefore does not cause the HTTP overhead. 

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
