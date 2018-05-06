***[Back to documentation root](README.md)***

**LimaCharlie Enterprise Only - Not LimaCharlie Cloud**

# Update Organization

Organization sensors are not automatically updated. You must first `update_binaries`. Once that is done the sensors
will automatically begin updating by themselves. When the `update_binaries` command is executed, the version of the
sensors used is the one pointed to by the `global/sensor_package`.

To issue the `update_binaries` command, you may either use a `POST` to the `/modules/{oid}` Control Plane endpoint
or an RPC: `./rpc.py c2/modulemanager update_org -d "{ 'oid' : '00000000-0000-0000-0000-000000000000' }"`