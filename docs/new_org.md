**LimaCharlie Enterprise Only - Not LimaCharlie Cloud**

# New Organization

[TOC]

## Creating the Organization
Creating an organization is easy and involves two simple parameters. The first parameter is the name of the new organization.
The name doesn't have to be anything special since it's only used as a human reference, internally a UUID identifies the organization.

The second parameter is a `sensor_quota`. This is the number of sensors an organization can have *online* at the same
time, meaning an organization with a quota of 10 can have a 100 sensors associated with it, but only 10 at a time can
be connected.

The organization can be created via a `POST` to the `{site}?/orgs` Control Plane endpoint

or it can be created via RPC: `./rpc.py c2/lcemanager create_org -d "{ 'name' : 'test_org', 'sensor_quota' : 0 }"`

## Priming Organization
At this point you now have a record for an organization, but you don't yet have sensors ready to be served, or an 
installation key for your sensors to register with. We have two more pieces of config to get going.

### Create Installation Keys
The Installation Keys are the long text strings that are given to the sensor when you install it. They are an encoded
version of the public cryptographic components necessary as well as the Organization Id and Installer Id.

***Don't ever share or make public your Installation Key. Someone in posession of the key can begin enrolling
sensors in your Organization. If this happens, you will have to delete the Installation Key and create a new one. Once
delete, anyone trying to register a new sensor with the deleted key will not be able to enroll the sensor.***

An Installation Key can be created by issuing a `POST` to the `/installationkeys/{oid}` Control Plane endpoint

or it can be created via RPC: `./rpc.py c2/enrollments add_installation_key -d "{ 'oid' : '00000000-0000-0000-0000-000000000000', 'desc' : 'Human description of that key usage.', 'tags' : [ 'vip', 'workstation' ] }"`

The `tags` you see in the RPC are Tags that will be automatically added to any sensors enrolling using this key.

### Update Binaries
Next you need to generate the binaries that will be customized for the new organization. Updating the binaries is a
common operation that is necessary when a new version of the sensors is available. When the global configuration
`global/sensor_package` is updated to the new version, organizations are not automatically updated (making change
management easier). To update to the new version, we need to update organization binaries.

So for a new organization, we must generate the first version of the binaries. This can be done via
a `POST` to the `/modules/{oid}` Control Plane endpoint

or it can be done via RPC: `./rpc.py c2/modulemanager update_org -d "{ 'oid' : '00000000-0000-0000-0000-000000000000' }"`
