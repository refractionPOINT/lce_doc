# Managing Tags

Tags in LCE are simple strings that can be associated with any number of sensors. A sensor can also have an arbitrary number
of tags associated with it.

Tags appear in every event coming from a sensor under the `routing` component of the event. This creates a lot of
duplication of data in the events, but it also greatly simplifies the writing of detection and response rules based
on the presence of specific tags.

Tags can be added to a sensor a few different ways:

1. Enrollment: the installation keys can optionally have a list of Tags that will get applied to sensors that use them.
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

## System Tags
We provide system level functionality with a few system tags.  Those tags are listed below for reference:

### latest
When you tag a sensor with _latest_, the sensor version currently assigned to the Organization will be ignored for that specific sensor, and the latest version of the sensor will be used instead. This means you can tag a representative set of computers in the Organization with the latest tag in order to test-deploy the latest version and confirm no negative effects.

### experimental
When you tag a sensor with _experimental_, the sensor version currently assigned to the Organization will be ignored for that specific sensor. An experimental version of the sensor will be used instead. This tag is typically used when working with the LimaCharlie team to troubleshoot sensor-specific issues.

### no_kernel
When you tag a sensor with _no_kernel_, the kernel component will not be loaded on the host. 

### debug
When you tag a sensor with _debug_, the debug version of the sensor currently assigned to the Organization will be used. 
