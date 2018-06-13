**LimaCharlie Enterprise Only - Not LimaCharlie Cloud**

# Update Organization

[TOC]

Organization sensors are not automatically updated. You must first `update_binaries`. Once that is done the sensors
will automatically begin updating by themselves. When an update is triggerred, the sensors will be updated to the most
recent sensor version globally available.

To issue the `update_binaries` command, you may either use a `POST` to the `/modules/{oid}` API endpoint.
