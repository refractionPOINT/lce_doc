***[Back to documentation root](README.md)***

# Managing Profiles

Profiles are used to specify a default behavior for the sensors. The main usage of the profiles is to specify which
events generated in the sensor are sent back to the cloud automatically. Since the sensors generate a lot of events
we usually want a subset of them to come back.

Managing profiles can be a simple one-time setup using the default profiles, or it can be a complex set of profiles
based on organizations and Tags.

## Simple Setup
For this simple version we will create 3 profiles based on the defaults for each platform (MacOS, Windows and Linux).
These profiles will apply to all organizations and all sensors. This is a sensible default and once applied (if satisfied)
you should never have to play with them again.

Issue a `POST` to `/profiles` REST endpoint of the Control Plane
or ```./rpc.py c2/hbsprofilemanager set_profile -d "{ 'aid' : '0.0.0.10000000.0', 'default_profile' : 'windows' }"
./rpc.py c2/hbsprofilemanager set_profile -d "{ 'aid' : '0.0.0.20000000.0', 'default_profile' : 'linux' }"
./rpc.py c2/hbsprofilemanager set_profile -d "{ 'aid' : '0.0.0.30000000.0', 'default_profile' : 'macos' }"```

## Complex Setup
The REST and RPC endpoints also support the `compiled_profile` argument instead of the `default_profile`. This allows
you create custom profiles. These custom profiles can then be associated with more granular agent ids (see [here](agentid.md)
documentation on how they work).

Learning the best way to customize profiles is to look at the [SensorConfig.py](/beach/hcp/utils/SensorConfig.py) file.
There you can find the default profiles built in the `getDefaultWindowsProfile` function and base your profiles off of the
`profile` variable as a simple Domain Specifi cLanguage.

## Listing Profiles
Issue a `GET` to `/profiles` REST endpoint of the Control Plane
or `rpc.py c2/hbsprofilemanager get_profiles`

## Deleting Profiles
Issue a `DELETE` to `/profiles` REST endpoint of the Control Plane
or `rpc.py c2/hbsprofilemanager del_profile -d "{ 'aid' : '00000000-0000-0000-0000-000000000000', 'tag' : [ 'tagOfProfileDelete' ] }"`
