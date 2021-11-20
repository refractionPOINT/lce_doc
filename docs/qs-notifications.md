# SMTP Notifications

LimaCharlie allows you to send endpoint telemetry wherever you want. With telemetry storage enabled you do not need to set up your own storage solution but you may want to get notified directly when a detection takes place.

Using the output configuration interface we can set up an SMTP module to send an email whenever a detection is caught.

You can configure the alert by visiting the Output tab and clicking the plus icon in the upper right corner. With the modal open, give the configuration a name and select smtp from the Module drop down. In order to ensure that you only get an email when a detection is triggered select Detections from the Stream dropdown.

![Configure SMTP Alerts](https://storage.googleapis.com/lc-edu/content/images/graphs/quickstart-notifications-1.png)

* `dest_host`: the IP or DNS (and optionally port) of the SMTP server to use to send the email.
* `dest_email`: the email address to send the email to.
* `from_email`: the email address to set in the From field of the email sent.
* `username`: the username (if any) to authenticate with the SMTP server with.
* `password`: the password (if any) to authenticate with the SMTP server with.
* `secret_key`: an arbitrary shared secret used to compute an HMAC (SHA256) signature of the email to verify authenticity. See Webhook section in the doc.
* `is_readable`: if 'true' the email format will be HTML and designed to be readable by a human instead of a machine.

**Example:**

```yaml
max: 2
case sensitive: false
values:
  - limacharlie.io
  - www.limacharlie.io
  - refractionpoint.com
  - www.refractionpoint.com
path: event/DOMAIN_NAME
event: DNS_REQUEST
op: string distance 
```

There are also several optional fields that can be used to limit the alerts to particular sensors, tags or investigation IDs (you can even limit the alerts to specific event types). These optional fields should be fairly self explanatory and their configuration is left at the discretion of the user.