---
title: Reliable Tasking
slug: reliable_tasking
---

# Reliable Tasking

## Overview
The Reliable Tasking service enables you to task a sensor (or set of sensors)
that are currently offline. The service will automatically send the tasks to
the sensor once it becomes online.

### Task
Record a task to be sent. The service will ensure the task is send at-least-once
if possible. A `ttl` allows you to automatically expire the task after a certain
number of seconds if it has not been successfully sent.

### List Tasks
List the tasks currently queued up for given sensors.

### REST

#### Task
```
{
  "action": "task",
  "task": "os_version"
}
```

The `task` is just a command line task.

Optionally, specify which endpoints to task by using one of:

* `sid`: a specific sensor ID
* `tag`: all sensors with this tag

Then, you can use `ttl` to specify how long the service should keep
trying to send the task. It is a number of seconds and defaults to 1 week.

#### List Tasks
```
{
  "action": "list"
}
```

Specify which endpoints to get the queued up tasks from using one of:

* `sid`: a specific sensor ID
* `tag`: all sensors with this tag