# Troubleshooting

## Sensor not showing as online.

### Determining Online Status
It is important to note that the online marker in the Web UI does not display real-time information. Instead it
refreshes its status between every 30 seconds to every few minutes depending on the page in question.

This means that an icon showing a sensor is not online may be lagging behind the actual status. If you need to
get a positive feedback on whether the sensor is online or not, go to the "Sensors" page which refreshes status more
often, moving to the "Sensors" page also triggers a refresh of the status right away.

### Reasons for Temporary Disconnect
Sensors connect to the cloud via a semi-persistent SSL connection. In general, if a host has connectivity to the
internet, the sensor should be online. There are, however a few situations that result in the sensor temporarily
disconnecting from the cloud for a few seconds. This means that if you temporarily see a sensor as offline when you
expect it to be online, give it 30 seconds, in most situations it will come back online with 5 seconds.

### Troubleshooting Steps
1. Make sure the sensor is actually offline by refreshing the Sensors page on the Web UI.
1. Wait 30 seconds and refresh the page again, to make sure the sensor was not momentarily reconnecting.
1. Check to see if the LimaCharlie service is running on the host.
  * On Windows, go to the Services control panel and check the status of the LimaCharlie service.
  * On MacOS, open the Activity Monitor application, make sure to select "Show All Processes" and look for the `rphcp` process.
  * On Linux, in a terminal issue `ps -elf | grep rphcp`.
1. If the service is not running, restart it. If you're not sure how to do it, a restart of the host will also work.

If these steps do not help, get in touch with us, we will help you figure out the issue. The best way of contacting us
is via our [Community Slack Channel](https://limacharlie.herokuapp.com/), followed by `support@limacharlie.io`.

## Sensor not Connecting

Sensors connect to the LimaCharlie.io cloud via an SSL connection on port 443. Make sure your network allows such
a connection. It is a VERY common port usually used for HTTPS so an issue is highly unlikely.

The sensor uses a pinned SSL certificate to talk to the cloud. This means that if you are in a network that enforces SSL introspection (a man-
in-the-middle of the SSL connections sometimes used in large corporate environments), this may prevent the sensor
from connecting. LimaCharlie uses a pinned certificate to ensure the highest level of security possible as usage of
off-the-shelf certificates can be leveraged by state sponsored (or advanced) attackers.

If your network uses SSL introspection, we recommend you setup an exception for the LimaCharlie cloud domain
relevant to you. Get in touch with us and we can provide you with the necessary information.