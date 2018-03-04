***[Back to documentation root](README.md)***

# Managing Tags

* TOC
{:toc}

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
Issue a `POST` to `/{sid}/tags` REST endpoint of the Control Plane
or `./rpc.py c2/taggingmanager add_tags -d "{ 'aid' : '00000000-0000-0000-0000-000000000000', 'tag' : [ 'someTagToAdd', 'another' ], 'ttl' : 60 * 60 * 24, 'by' : 'analyst_1' }"`

### Detection & Response
In detection and response rules, you may use the `sensor.tag( 'someTagToAdd', ttl = 60 * 60 * 24 )` expression.
This example expression would add the `someTagToAdd` tag to the sensor whose event is being evaluated, and that tag would
remain present for 1 day (`60 * 60 * 24` seconds).

## Removing Tags

### Manual API
Issue a `DELETE` to `/{sid}/tags` REST endpoint of the Control Plane
or `./rpc.py c2/taggingmanager del_tags -d "{ 'sid' : '00000000-0000-0000-0000-000000000000', 'tag' : [ 'tagToDelete' ], 'by' : 'analyst_1' }"`

### Detection & Response
In detection and response rules, you may use the `sensor.untag( 'tagToDelete' )` expression.

## Checking Tags

### Manual API
Issue a `GET` to `/{sid}/tags` REST endpoint of the Control Plane
or `./rpc.py c2/taggingmanager get_tags -d "{ 'sid' : '00000000-0000-0000-0000-000000000000' }"`

### Detection & Response
In detection and response rules, you may use the `sensor.isTagged( 'checkForThisTag' )` expression which returns True if 
the sensor has this tag.
