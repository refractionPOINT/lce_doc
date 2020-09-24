# Responder

## Overview
The Responder service is able to perform various incident response tasks for you.

### Sweep
A sweep is an in-depth look through the state of a host. The sweep will highlight parts of the activity that are suspicious. This provides you with a good starting position when beginning an investigation. It allows you to focus on the important things right away.

The types of information returned by the sweep is constantly evolving but you can expect it to return the following information:

* A full list of processes and modules
* A list of unsigned binary code running in processes
* Network connections with a list of processes listening and active on the network
* Hidden modules
* A list of recently modified files
* Unique or rare indicators of compromise

### REST

#### Sweep
```
{
  "action": "sweep",
  "sid": "70b69f23-b889-4f14-a2b5-633f777b0079"
}
```
