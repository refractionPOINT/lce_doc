# Getting Started with LimaCharlie

LimaCharlie is infrastructure to connect sources of security data, automate activity based on what's being observed, and forward data where you need it. There's no single correct way to use it.

That said, let's set up LimaCharlie to provide basic EDR capabilities. This guide will cover:

1. [Creating a new **Organization**](getting-started.md#creating-an-organization)
2. [Connecting a **Sensor** to the Organization](getting-started.md#connecting-a-sensor)
3. [Adding **Sigma Rules** to detect known threat signatures](getting-started.md#adding-rules)
5. [Forwarding detections to an external destination via **Output**](getting-started.md#forwarding-via-output)

All of this is possible to try for free (payment is only required when scaling up beyond 2 sensors).

Let's get started!

## Creating an Organization

LimaCharlie organizations are tenants in the cloud, conceptually equivalent to "projects". They're isolated from one another and can be configured to suit the needs of each deployment.

> For an overview of how tenancy and access are managed, see the [Access Overview](access-overview.md).

If you haven't already done so, sign up for a free account at [app.limacharlie.io](https://app.limacharlie.io/signup). 

After accepting the Terms of Service, you'll be offered a prompt to create an organization in a selected `Region` with a globally unique `Name`. Note that the selected Region for an organization is permanent and data migration is not allowed.

Once your organization is created, you'll be greeted with what _would_ be a list of Sensors connected to the organization, but there's none there yet. Let's add one.

## Connecting a Sensor

From the Sensors page in your new organization, click `Add Sensor` to open the setup flow for new sensors. Sensors, generally speaking, are executables that install on hosts and connect them to the cloud so they can send telemetry, receive commands, and sometimes expose other capabilities.

> For a full overview of types of sensors and their capabilities, check out the [Sensors Overview](sensors.md).

The setup flow should make this process straighforward. For example's sake, let's say we're installing a sensor on a Windows 10 (64 bit) machine we have in front of us. 

* Choose the Windows sensor type
* Create an installation key - this registers the executable to communicate securely with your organization
* Choose the `64 bit (.exe)` installer
* Follow the on-screen instructions to execute the installer properly
* See immediate feedback when the sensor registers successfully with the cloud

> Since sensors are executables that talk to the cloud, antivirus software and networking layers may interfere with installation. For this, consult [Troubleshooting](troubleshooting.md) or visit the [help center](https://help.limacharlie.io/).

With a Windows sensor connected to the cloud, you should gain a lot of visibility into the endpoint. If we view the new sensor inside the web application, we'll have access to views such as:

* `Timeline`: the viewer for telemetry events being collected from the endpoint
* `Processes`: the list of processes running on the endpoint, their level of network activity, and commands to manipulate processes (i.e. kill / pause / resume process, or view modules)
* `File System`: an explorer for the endpoint's file system, right in the browser
* `Console`: a safe shell-like environment for issuing commands
* `Live Feed`: a running view of the live output of all the sensor's events

With telemetry coming in from the cloud, let's add rules to detect potentially malicious activity. 

## Adding Rules

Writing security rules and automations from scratch is a huge effort. To set an open, baseline standard of coverage, LimaCharlie maintains a [`sigma`](https://app.limacharlie.io/add-ons/detail/sigma) add-on which can be enabled for free, and is kept up to date with the [openly maintained threat signatures](https://github.com/SigmaHQ/sigma). 

Enabling the Sigma add-on will automatically apply rules to your organization to match these threat signatures so we can begin to see Detections on incoming endpoint telemetry. 

> Writing your own rules is outside the scope of this guide, but we do encourage checking out the [Introduction to Detection & Response rules](dr.md) when you're finished.

## Forwarding via Output

Security data generated from sensors is yours to do with as you wish. For example's sake, let's say we want to forward detections to an [Amazon S3 bucket](https://aws.amazon.com/s3/) for longer-lived storage of detections

From the Outputs page in your organization, click `Add Output` to open the setup flow for new outputs. Again, the setup flow should make this process straightforward. 

* Choose the Detections stream
* Choose the Amazon S3 destination
* Configure the Output and ensure it connects securely to the correct bucket:
  * Output Name
  * Bucket Name
  * Key ID
  * Secret Key
* Optionally, view samples of the stream's data (assuming recent samples are available)

With this output in place you can extend the life of your detections beyond the 1 year LimaCharlie retains them, and even make them available for consumption from any tool that can pull from S3. 

## Next Steps

This guide is meant to be illustrative and give an overview of what pieces a minimal setup might use. 

LimaCharlie's core capabilities are relatively unopinionated, independent, and highly configurable to enable you to build out your deployments without the overhead of hosting and scaling them.

For further learning, dive deeper into the specific area that reflects your needs.

### References

* [Sensors](sensors.md)
* [Events](events-overview.md)
* [Commands](sensor-commands-overview.md)
* [Artifact Collection](external_logs.md)
* [Payloads](payloads.md)
* [Rules](dr.md)
* [Outputs](outputs.md)
* [Infrastructure as Code](configs.md)
* [Access Control](access-overview.md)

