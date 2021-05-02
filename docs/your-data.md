# LimaCharlie's Access to Your Data
We believe that privacy is a fundamental human right.

This document outlines the steps we take to maintain your privacy and mitigate insider threats.


## When and why LimaCharlie staff may access your data
LimaCharlie staff only access your private data when you contact us and give us permission to do so.  We will always ask for your permission before we access your private telemetry data.

We consider your sensors and telemetry data to be private and confidential.  We understand the tremendous power that is being entrusted to us while we have access to this data.  We promise to only access your organization for the exclusive purpose of providing you with the assistance you request from us.  We treat your private and confidential information with at least the same due care as we do with our own confidential information, as outlined in our [privacy policy](https://app.limacharlie.io/privacy).


## Third-Party Access
The only time we provide your data to a third party is with your explicit consent.
(e.g. when you set up an Output in LimaCharlie, you're explicitly telling us to send your data to a 3rd party)


## Control Measures

### Transparency
We use transparency as a mitigating control against insider threats.  In particular, when we access your organization data:

1)  An entry is made to the Audit Log in your organization.  You can access the audit log in the web interface and via the [API](https://doc.limacharlie.io/docs/api/container/static/swagger/v1/swagger.json/paths/~1audit~1%7Boid%7D/get).  We also provide the ability for you to [send audit log data out](https://doc.limacharlie.io/docs/documentation/docs/outputs.md#google-cloud-storage-1) of LimaCharlie immediately to a write-only bucket that you control in your own environment.

2)  An entry is made to the LimaCharlie infrastructure logs.  These logs are regularly audited.


### Role-Based Access Control
LimaCharlie staff access to customer data is restricted to only those who need it to perform their official duties.

We use role-based access control systems to provide granular control over the type of data access granted.

Access to customer organizations is granted programatically as to provide a security control.

We require that our staff undergo a background check and take training, including privacy training, prior to being allowed to access customer data.

We are currently going through the SOC 2 (Type 2) compliance process.  A copy of our audit report can be provided upon request.