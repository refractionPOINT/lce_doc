# LimaCharlie Digger

[TOC]

## Overview
The LimaCharlie.io Digger is a web application that allows you to dig through your data and interact with your LimaCharlie.io deployment.
It is accessible from [https://digger.limacharlie.io](https://digger.limacharlie.io). What makes the Digger different from other such interfaces
is that it is not connected in any way to the LimaCharlie.io infrastructure as a data source. It is designed to be configured locally only, we never
get access to your credentials or your data, the Digger web application is standalone.

The Digger uses APIs accessible to everyone. This makes it a good platform to get ideas for integrations and available APIs.

## How does it work?
It's simple, limacharlie.io allows you to send your data wherever you want. What digger does is it takes crendentials for wherever your data currently
resides, and accesses it directly from your browser.

For example, if you send your data to Amazon S3, you can make it accessible through Digger by configuring read-only crendentials to your S3 bucket. Your 
browser will then use the S3 REST API to query your data and display it.

Some workbenches (this is what we call the various tools available in Digger) require access to your limacharlie.io deployment through the API. This means
that to use them you need to configure a limacharlie.io API key.

## Workbenches
### Console
This workbench requires a limacharlie.io [API key](api_keys.md) with Read, Write, Execute and Output privileges.

It will provide you with a live console to your LimaCharlie.io agents where you can [execute commands](sensor_commands.md) and see their responses in 
realtime to your browser.

This is great for live incident response, investigation or to check the output of various commands before adding them to 
the [automated detection and response](dr.md).

To get going, simply select an agent from the left list. After a second, an indicator should appear beside the agent hostname indicating whether the computer
is online or offline. At the moment we only support sending real-time commands to an agent that is online. Then type a command in the input at the bottom
of the screen. The format is the one described in the [commands](sensor_commands.md) documentation. After a few seconds you should see the response from 
your command appear in the console.

### Explore
This workbench requires a data source to be configured. At the moment of writing this documentation, only Amazon S3 is supported as a data source. Make
sure your S3 Output is configured with the `is_indexing` option enabled. The `is_compression` option is also supported transparently by Digger.

To get going, select a sensor from the list on the left. Then select a start and end time. Be careful here, agents can produce a LOT of data over time. It's
probably wise to keep this length of time to under an hour in most cases. Also note that this workbench uses some light indexing in the S3 data, and these
indexes are produced once per hour. This means that data in the last hour may be incomplete.

You technically don't HAVE to select an agent. If you don't, indexes will not be used and all data from all sensors during the time period will be returned 
so be careful.