# Managing Tags

[TOC]

Tags in LCE are simple strings that can be associated with any number of sensors. A sensor can also have an arbitrary number
of tags associated with it.

Tags appear in every event coming from a sensor under the `routing` component of the event. This creates a lot of
duplication of data in the events but it also simplifies greatly the writing of detection and response rules based
on the presence of specific tags.

Tags can be added to a sensor a few different ways:
1. Enrollment: the installation keys can optionaly have a list of Tags that will get applied to sensors that use them.
1. Manually: using the API as described below, either manually by a human or through some other integration.
1. Detection & Response: automated detection and response rules can programatically add a tag (and check for tags).

## Adding Tags

### Manual API
Issue a `POST` to `/{sid}/tags` REST endpoint

### Detection & Response
In detection and response rules

## Removing Tags

### Manual API
Issue a `DELETE` to `/{sid}/tags` REST endpoint

### Detection & Response
In detection and response rules

## Checking Tags

### Manual API
Issue a `GET` to `/{sid}/tags` REST endpoint

### Detection & Response
In detection and response rules
