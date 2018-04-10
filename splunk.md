***[Back to documentation root](README.md)***

# Splunk

* TOC
{:toc}

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

## App
A basic Splunk App is available to help you start going through the LimaCharlie data. 
It is currently available [here](https://lcio.nyc3.digitaloceanspaces.com/lce.spl)
