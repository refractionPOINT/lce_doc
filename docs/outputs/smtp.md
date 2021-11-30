# SMTP
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