# Replicants

[TOC]

## Overview
Replicants can be thought of as digital automatons: expert driven algorithms which utilize some basic artificial intelligence to perform tasks that would normally be completed by humans.

## Using
Each replicant has a particular specialization and can be enabled in the same manner as any [Add-on](user-addons.md) through the user interface of the web application.

Once enabled the replicant will show up in the War Room which is linked off of the main menu inside of the Organization view of the web application.

## Available Replicants
Below you will find a brief explanation of each available replicant, along with details on the particular configuration requirements.

### Yara
The Yara replicant is designed to help you with all aspects of Yara scanning. It takes what is normally a manual piecewise process, provides a framework and automates it.

Once configured, Yara scans can be run on demand for a particular endpoint or continuously in the background across your entire fleet.

There are three main sections to the Yara replicant.

#### Sources
This is where you define the source for your particular Yara rule(s). Source URLs can be either a direct link to a given Yara rule or links to a Github repository with a collection of signatures in multiple files.

An example of setting up a source using this repo: [Yara-Rules](https://github.com/Yara-Rules/rules)

For `Email and General Phishing Exploit` rules we would link the following URL, which is basically just a folder full of .yar files.

[https://github.com/Yara-Rules/rules/tree/master/email](https://github.com/Yara-Rules/rules/tree/master/email)

Giving the source a name and clicking the Add Source button will create the new source.

#### Rules
Rules define which sets of sensors should be scanned with which sets of Yara signatures (or sources).

Filter tags are tags that must ALL be present on a sensor for it to match (AND condition), while the platform of the sensor much match one of the platforms in the filter (OR condition).

#### Scan
To apply Yara Sources and scan an endpoint you must select the hostname and then add the Yara Sources you would like to run as a comma separated list.

### Responder
The Responder replicant is able to perform various incident response tasks for you.

#### Sweep
A sweep is an in-depth look through the state of a host. The sweep will highlight parts of the activity that are suspicious. This provides you with a good starting position when beginning an investigation. It allows you to focus on the important things right away.

The types of information returned by the sweep is constantly evolving but you can expect it to return the following information:

* A full list of processes and modules
* A list of unsigned binary code running in processes
* Network connections with a list of processes listening and active on the network
* Hidden modules
* A list of recently modified files
* Unique or rare indicators of compromise

### Integrity
Integrity helps you manage all aspects of File and Registry integrity monitoring.

#### rules
Rules define which file path patterns and registry patterns should be monitored for changes for specific sets of hosts.

Filter tags are tags that must ALL be present on a sensor for it to match (ANDed), while the platform of the sensor much match one of the platforms in the filter (ORed).

Patterns are file or registry patterns, supporting wildcards (*, ?, +). Windows directory separators (backslash, "\") must be escaped like "\\".
