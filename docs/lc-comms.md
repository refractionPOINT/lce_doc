# Comms: Operations at Scale

Comms is designed to enable teams to respond to detections in real-time. It is not a SIEM and can most easily be described as Slack for incident responders. It is built close to the metal and provides full visibility of the actions your team is taking to mitigate any threats across all organizations you have access to.

When a detection happens a Room is generated for your team to assign ownership, assess indicators of compromise, and issue commands. Rich linking of entities allows your team to observe trends across multiple detections: like an endpoint with several detected threats, or a common detection popping up on several boxes. Navigate between them easily or merge rooms together to create a shared context for complex emerging issues.

## Rooms

A Room is a virtual space where team members can collaborate. When a detection is triggered a Room is automatically created. Rooms can also be created manually.

## Room Filters

Room Filters allows you to filter the list of Rooms viewable in the web application across several dimensions, listed as follows.

### Status

Open will display Rooms that are open for investigation.
Closed will display Rooms that have been closed.
Archived will display Rooms that have been put into an archived state.

### Date Range

Setting a date range between Time Since and Time Until will limit the results to detections that took place within the given time window.

### Organization

Select detections from a particular Organization <link>

### Created By

Limit results to Rooms created by the given user.

### Assignee

Limit results to Rooms with the given Assignee

### Commands

Using a slash-command format, operators can issue commands directly from a Room. Comms currently supports the following commands.

/close [reason]

When an investigation is done operators can use the close command to shut it down and leave a comment.

/link [rid] [type] [value] [mid]

/search [type] [name] [info] [case_sensitive] [with_wildcards] [in_logs] [per_object]

/task [sid] [task]

Using Task any sensor can be tasked with any Sensor command <link>

### Links

Links provide quick access to resources related to the given investigation.

Currently links support:

Sensor
Rooms
Detection
