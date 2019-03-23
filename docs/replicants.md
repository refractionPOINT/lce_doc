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

An example of setting up a source using this repo (https://github.com/Yara-Rules/rules)

For email and general phishing exploits we would link the following URL, which is basically just a folder full of .yar files.

https://github.com/Yara-Rules/rules/tree/master/email

Giving the source a name and clicking the Add Source button will create the new source.
