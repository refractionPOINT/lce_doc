## Core Concepts
### Sensors
The LimaCharlie sensor is a cross platform endpoint sensor (agent). It is a low-level, light-weight sensor that executes detection and response functionality in real-time.

The sensor provides a wide range of advanced capability.

* Flight Data Recorder (FDR) type functionality like Processes, Network Connections, Domain Name requests etc.
* Host isolation, automated response rules, intelligent local caching of events for in depth Incident Response (IR)
as well as some forensic features like dumping memory.

Sensors are designed to limit the potential for abuse resulting from unauthorized access to the LimaCharlie platform.
This is achieved by limited open-ended commands as well as commands that could enable an attacker to
covertly upload malicious software to your hosts. This means the LimaCharlie sensor is extremely powerful
but also keeps its "read-only" qualities on your infrastructure. Of course, all access and interactions with the hosts
are also logged for audit both within the cloud and tamper-proof forwarding to your own infrastructure.

Full commands list is in the [Sensor Commands section](sensor_commands.md).

### Installer Key
Installer Keys are used to install a sensor. By specifying a key during installation the sensor can cryptographically be tied to your account.
Get more details in the [Installation Keys section](manage_keys.md).

### Tags
Sensors can have Tags associated with them. Tags are added during creation or dynamically through the UI, API or Detection & Response Rules.
Get more information in the [Tagging section](tagging.md).

### Detection & Response Rules
The Detection & Response Rules act as an automation engine. The Detection component is a rule that either matches an event
or not. If the Detection component matches, the Response component of the rule is actioned. This can be used to automatically
investigate, mitigate or apply Tags.

Detailed explanation in the [Detection & Response section](dr.md).

### Insight
Insight is our built-in data retention and searching. It is included within our 2 sensor free tier as well.

When you enable Insight, we configure everything for you so that you get access to one year of your data for visualization and searching.

You don't *have to* use the built-in data retention; you can forward data to your infrastructure
directly if you'd like. In general though, it is much simpler and a better experience to use Insight. If you prefer not to use Insight,
go through the next section (Outputs).

### Outputs
If you are using Insight (data retention) this section is optional.

LimaCharlie can relay the data somewhere for longer term storage and analysis. Where that data is sent depends on which Outputs
are activated. You can have as many Output modules active as you want, so you can send it to multiple syslog destinations using
the Syslog Output module and then send it to some cold storage over an Scp Output module.

Output is also split between four categories: "event", "detect", "audit" and "deployment". Selecting a Stream when creating an Output
will select the relevant type of data to flow through it.

Exact configuration possibilities in the [Output section](outputs.md).

### API Keys
The API keys are represented as UUIDs. They are linked to your specific organization and enable you to programatically acquire
authorization tokens that can be used on our REST API. See the [API Key section](api_keys.md) for more details.

