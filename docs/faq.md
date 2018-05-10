# FAQ

[TOC]

### Why do I get Unauthorized errors from the REST API?
* Make sure the API endpoint you're trying to reach is enabled
  for LimaCharlie Cloud customers. The supported endpoints are
  the ones listed in the "LimaCharlie Cloud" category [here](https://api.limacharlie.io/static/swagger/#/LimaCharlie_Cloud).
* If you are using the tasking API to send tasks to sensors, make sure you are
  subscribed to the the "tasking" add-on, otherwise your access tokens will lack the
  privilege required.

### How do I select which events are sent back to me?
* Only certain events are sent back to the cloud for performance reasons.
* All events sent to the cloud are always sent to whatever Output you've configured.
* You can trigger the retrieval of additional events from the sensor through two ways:
  1. Sending the [`history_dump`](sensor_commands.md) task to a sensor will tell it to send home all events cached in memory.
  1. Using the [`add_exfil`](sensor_commands.md) task to a sensor will tell it to send all instances of a specific event
     home for a specific amount of time.
* This means a common strategy is to have "first level" detections that look for general
  suspicious behavior, and when necessary for those detections to trigger `history_dump` to get full context.
  