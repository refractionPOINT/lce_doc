# Data Visualization

[TOC]

The Data Visualization page allows users to search for a variety of data types across the entire fleet for up to a year, as well as a detailed pull of telemetry from any given endpoint for the given time range.

## Data Types

The data types that can be searched for are:

* Domain: Exact match for a given domain (www.google.com returns a different result than google.com)
* SID: Search by sensor ID. Searching with this parameter will bring back details across all types for  the given endpoint for the given time range.
* IP: IP addresses that requests are made to and from.
* File Path: Search for observed file paths. 
* File Hash: Search for observed file hashes.
* User: Search by username.
* File Name: Search by file name.

## Node Size

The node - as it is displayed on the graph - is calculated based on how many events of the given type are bucketed into the given hour represented by the x axis (you can also hover over the node to get the time). These event are bucketed by type and represent events across multiple endpoints. Clicking on a node will bring up a list of the given events in the lower menu. Clicking on a listed event in the lower menu will bring up sensor details which can be further expanded into the tabbed region on the lower right.

## Prevalence 

The prevalence is represented by a given nodes position on the y axis. The prevalence represents the number of hosts the specific type instance that has been observed on during the time period.

## Opacity

Opacity is related to the number of objects present in the given node in relation to the largest object returned for the given data set (this measure is meant to highlight outliers).

## Information Panel

The information panel in the lower half of the screen is where information is exposed as you interact with graph.

### Objects

Clicking on a node in the graph will populate this area with type and name(s) for the node.

### Sources

Clicking on an object name will populate the Sources tab with the Source ID(s) and the first time that object was seen on the given source.

### Tabbed Data 

The tabbed data section shows details for a given source. The information is spread across three tabs as outlined below.

#### Source

When a Sensor ID is selected the Source tab will display the following data. It also provides a link into the Historical Insight UI at the time when the selected object was observed.

* Hostname
* Last Seen Timestamp
* Enrollment Timestamp
* External IP
* Internal IP
* Installer ID
* Organization ID

#### Metadata 

The metadata represents additional data specific to the selected object that may be useful. For example, the metadata for a domain would be the underlying IP address.

#### Data

The raw JSON telemetry for events at the time of the given event.




