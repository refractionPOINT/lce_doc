
# Kafka
Output events and detections to a Kafka target.

* `dest_host`: the IP or DNS and port to connect to, format `kafka.myorg.com`.
* `is_tls`: if `true` will output over TCP/TLS.
* `is_strict_tls`: if `true` will enforce validation of TLS certs.
* `username`: if specified along with `password`, use for Basic authentication.
* `password`: if specified along with `username`, use for Basic authentication.
* `routing_topic`: use the element with this name from the `routing` of the event as the Kafka topic name.
* `literal_topic`: use this specific value as a topic.

Example:
```yaml
dest_host: kafka.corp.com
is_tls: "true"
is_strict_tls: "true"
username: lc
password: letmein
literal_topic: telemetry
```