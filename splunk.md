# Splunk

Splunk can easily be configured to ingest LimaCharlie data.

The most common problem is the breaking up of all the JSON events in the same file/input.
This can be done by adding the following to your `props.conf`, assuming the Splunk `sourcetype` you are using is called `limacharlie`.

## props.conf
```
[limacharlie]
SHOULD_LINEMERGE = false
```

## inputs.conf
```
[batch:///home/lc/data/]
disabled = false
sourcetype = limacharlie
move_policy = sinkhole
```