# Troubleshooting

## Sensor not showing as online.

### Determining Online Status
It is important to note that the online marker in the Web UI does not display real-time information. Instead it
refreshes its status between every 30 seconds to every few minutes, depending on the page in question.

This means that an icon showing a sensor as not online may be lagging behind the actual status. If you need to
get a positive feedback on whether the sensor is online or not, go to the "Sensors" page which refreshes status more
often. Moving to the "Sensors" page also triggers a refresh of the status right away.

### Reasons for Temporary Disconnect
Sensors connect to the cloud via a semi-persistent SSL connection. In general, if a host has connectivity to the
internet, the sensor should be online. There are, however, a few situations that result in the sensor temporarily
disconnecting from the cloud for a few seconds. This means that if you notice a sensor is offline when you
expect it to be online, give it 30 seconds, and in most situations it will come back online within 5 seconds.

## Sensor not Connecting
Sensors connect to the LimaCharlie.io cloud via an SSL connection on port 443. Make sure your network allows such
a connection. It is a very common port typically used for HTTPS so an issue is highly unlikely.

The sensor uses a pinned SSL certificate to talk to the cloud. This means that if you are in a network that enforces SSL inspection (a man-in-the-middle of the SSL connections sometimes used in large corporate environments), this may prevent the sensor from connecting. LimaCharlie uses a pinned certificate to ensure the highest level of security possible, as usage of off-the-shelf certificates can be leveraged by state-sponsored (or advanced) attackers.

If your network uses SSL inspection, we recommend you setup an exception for the LimaCharlie cloud domain
relevant to you. Get in touch with us and we can provide you with the necessary information.

Sensors since version 4.21.2 also generate a local log file able to be used to help pinpoint the level at which
the connectivity fails. This log file is located:

* Windows: c:\windows\system32\hcp.log
* MacOS: /usr/local/hcp.log
* Linux: ./hcp.log

This log provides a simple line for each basic step of connectivity to the cloud. It only logs the first
connection attempted to the cloud and rolls over every time the sensor starts. A successful connection
should look like:

```
hcp launched
configs applied
conn started
connecting
ssl connected
headers sent
channel up
```

If you are having trouble getting your sensor connected to the cloud, we recommend that you attempt the following on the host:
1. Restart the LimaCharlie service.
1. Check that the service is running.
    * The service process should be called `rphcp`.
1. If the sensor still shows as not online, check the `hcp.log` file mentioned above:
    * Check that the "configs applied" step is reached. If not, it may indicate the Installation Key provided is wrong or has a typo.
    * Check that the proxy is mentioned in the log if you are using a proxy configuration.
    * Check that the "ssl connected" step is reached. If not, this indicates a network configuration issue connecting to the cloud.
    * Check that the "channel up" step is reached. If not, this could indicate one of a few things:
        * Your sensor was deleted (through API or Web interface) from the org. If so, reinstall to get a new identity.
        * Your organization may be out-of-quota if more sensors than the maximum number you've set in the Billing section are trying to connect at once. Increase your quota and wait a few minutes to fix it.
        * If this is a brand new sensor install, make sure the Installation Key you're using still exists in your Org. Once deleted, an Installation Key cannot be used for NEW sensors, but old sensors that were installed using it will still work fine.

## Sensor not Responding
Your sensor shows up as "online", but does not respond to interactive tasking.

The most common cause of this problem is a partial uninstall and reinstall of the sensor on the host.
The sensor, when installed, creates local files that record the identity the sensor has with the cloud.

When uninstalling, the `-r` mode leaves these identification files behind, so that if you reinstall a
new version of the sensor which talks to the same Org in LimaCharlie, the sensor ID will be the same.
On the other hand, the `-c` mode will remove all the identity files as well.

If you uninstall with `-r` and re-enroll the sensor to a different Org, as can often happen during testing,
the files on disk that include some cryptographic material will not match with what the cloud expects. This may result in taskings being refused by the sensor.

To make sure this is not what's happening, uninstall the sensor with `-c`. Double-check that the local
files `hcp`, `hcp_hbs` and `hcp_conf` are deleted before reinstalling. On Windows these should be 
in `c:\windows\system32` while on macOS they should be in `/usr/local`.

## Additional Help
If these steps do not help, get in touch with us, and we will help you figure out the issue. The best way of contacting us
is via our [Community Slack Channel](https://slack.limacharlie.io/), followed by `support@limacharlie.io`.
