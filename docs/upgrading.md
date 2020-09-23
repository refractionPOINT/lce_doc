# Upgrading Sensors

Sensors are never upgraded without your consent. Upgrading sensors does not require the manual re-installation via installers.

LimaCharlie indicates to you when a newer version is available for upgrade on the Web Dashboard and Sensor Downloads page.

At all times we provide a `Stable` version and a `Fallback` version. When a new version of the sensor is available, it
is made the new `Stable`.

The LimaCharlie Web UI (Sensor Download page) allows to upgrade or downgrade your sensors to `Stable` or `Fallback` at will.

When you click to upgrade or downgrade, the process begins automatically and over the next hour (or as sensors come online) they
will be moved to the appropriate version.

When a sensor upgrades, it performs a soft restart of the sensor (not the host computer). This means the sensor may
appear offline for a minute during that soft restart.

This process can also be put in motion using the `/modules` [REST endpoint](https://api.limacharlie.io/static/swagger/#/modules).
