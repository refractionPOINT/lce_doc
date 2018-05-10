# Managing Profiles

[TOC]

** WARNING **
Profiles are currently not modifiable by users of LimaCharlie.io.
This is due to the origins of the Open Source LimaCharlie sensor, we are
in the process of porting them to a new mechanism that will allow users
to customize various sensor configurations further.


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

If you would like customizations to the profiles you use, do not hesitate to contact us at `support@refractionpoint.com` where
we can help you.

## Listing Profiles
Issue a `GET` to `/profiles` REST endpoint of the Control Plane
or `rpc.py c2/hbsprofilemanager get_profiles`

## Deleting Profiles
Issue a `DELETE` to `/profiles` REST endpoint of the Control Plane
or `rpc.py c2/hbsprofilemanager del_profile -d "{ 'aid' : '00000000-0000-0000-0000-000000000000', 'tag' : [ 'tagOfProfileDelete' ] }"`

## Profile Matching Priority
When looking for a profile to match a sensor, a specific search order is used:
1. Evaluate rules that refer to a specific Sensor ID.
1. Evaluate rules that refer to a specific Organization ID.
1. Evaluate all other rules.

Within each of those evaluations, a rule that specifies both an AgentID ***and*** a Tag will have priority over a rule
that only matches an AgentID.

# Default Profiles (LimaCharlie Cloud)
Sensors on LimaCharlie Cloud have default profiles. The sensors can be configured at runtime after, but the values in
the profiles are applied before anything else.

## Events to Cloud
By default, the events sent to the cloud are the ones that are not too chatty. For example, we do not send home all
netflow-type events or all module loads. But we do send roll-up versions like first 10 network connections per process
(called NETWORK_SUMMARY) and unique file path / file hash combinations (CODE_IDENTITY).

The events sent back can be configured by using the [sensor commands](sensor_commands.md). Please be kind to other
LimaCharlie Cloud users as this is a multi-tenant environment, and users who abuse this may be disabled (like sending
all events all the time) as it degrades everyone's service.

## File Type Tracker
This collection module tracks processes accessing various file types. It does this by associating file extensions with
rule numbers. The first time a process does an operation with a file matching a rule number, an event is generated. This
can allow you to report any processes accessing MS Word documents for example. This is the default rule set:

### Rule 1
File extensions: doc, docm, docx

### Rule 2
File extensions: xlt, xlsm, xlsx

### Rule 3
File extensions: ppt, pptm, pptx, ppts

### Rule 4
File extensions: pdf

### Rule 5
File extensions: rtf

### Rule 50
File extensions: zip

### Rule 51
File extensions: rar

### Rule 64
File extensions: locky, aesir

## Document Collector
This collection modules caches in memory any new files created that match extension and location patterns. It keeps them
in memory (up to a limit). When it caches a document, it emits a NEW_DOCUMENT event with basic information on the cached file.

This is useful for malicious files or documents that delete themselves, it allows you to retrieve a copy after the fact using
the `doc_cache_get` sensor command. The following patterns are cached by default:

File extensions: bat, js, ps1, sh, py, exe, scr, pdf, doc, docm, docx, ppt, pptm, pptx, xlt, xlsm, xlsx, vbs, rtf, hta.
File paths: `windows\\system32\\`.
