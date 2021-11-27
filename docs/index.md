# LimaCharlie Docs

Welcome to the LimaCharlie docs &mdash; the best place to learn about the core concepts available in LimaCharlie's platform. 

* Looking for the API? Check out our [Swagger API documentation](https://doc.limacharlie.io/docs/api/container/static/swagger/v1/swagger.json).
* Looking for an answer to a specific question? Check out our [help center](https://help.limacharlie.io).

> Get up and running fast with the [Quickstart Guide](lcc_quick_start.md).

## Core Concepts
 
LimaCharlie provides cloud-based security infrastructure. Flexible primitives like Sensors, Rules, and Outputs enable security engineering and security operations teams to build out their security posture, practices, and tool chain on a common platform. 

Using infrastructure-as-code, all of this can be tested and repeated across organizations & environments.

For a wider view of what's possible in LimaCharlie, check out the [Features Overview](features.md).

Here are the core components of the platform:

### Sensors

Software that bridges a source of events and the LimaCharlie cloud, often with the ability to take action. EDR-class sensors include [Windows](sensors/windows.md), [Mac](sensors/mac.md), and [Linux](sensors/linux.md). Sensors can also bring in sources such as syslog, AWS Cloud Trail, or 1Password.

* Get started with [Sensors](sensors.md)

### Events

Events are streamed through the LimaCharlie cloud in a standard JSON format with consistent routing information. A large collection of well-structured events can be collected from sensors.

* Get started with [Events](events-overview.md)

### Detection & Response Rules

Detectors-as-code that match incoming events and trigger actions in response.

* Get started with [Detection & Response Rules](dr.md)

### Net Policies

Policies for providing fine-grained endpoint-to-endpoint networking via [Net](sensors/net.md) sensors.

* Get started with [Net Policies](lc-net.md)

### Outputs

Streams that point toward external destinations (like S3, Google Cloud Storage, or Slack).

* Get started with [Outputs](outputs.md)

### Add-ons

Extends the capabilities of an organization by connecting Services or Lookup lists.

* Get started with [Add-ons](user_addons.md)

## Other Topics

* [Feature Overview](features.md)
* [Top Use Cases](top-use-cases.md)
* [Frequently Asked Questions](faq.md)
* [Troubleshooting](troubleshooting.md)
* [Billing](billing.md)

## Resources

* For answers to particular questions, check out the [Help Center](https://help.limacharlie.io).
* Looking for a course to get started? Check out our [courses](https://edu.limacharlie.io/).
* Want to join the LimaCharlie community? Join our [Slack](https://slack.limacharlie.io).
* Looking for a demo? [Book a call](https://calendly.com/limacharlie-demo) or sign up for an upcoming [webinar](https://www.limacharlie.io/webinar).
* Want videos? Check out the [YouTube Channel](https://www.youtube.com/limacharlieio).