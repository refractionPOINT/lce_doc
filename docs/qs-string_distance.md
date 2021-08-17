# Levenshtein Distance

Another good starting item to set up as part of your initial posture is Levenshtein distance. A common phishing practice employed by bad actors is to use a domain that is similar enough to the given organization that a user will not recognize the difference on a quick glance. The detection in this example will catch when a domain that is similar (but different) to the ones being watched shows up on the endpoint. This particular notification is fired when said domain is one or two characters different than the ones we are monitoring.

```yaml
max: 2
case sensitive: false
values:
  - limacharlie.io
  - www.limacharlie.io
  - refractionpoint.com
  - www.refractionpoint.com
path: event/DOMAIN_NAME
event: DNS_REQUEST
op: string distance 
```

