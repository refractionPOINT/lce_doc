# PagerDuty

## Overview
The PagerDuty service allows you to trigger events within PagerDuty. It requires
you to setup the PagerDuty access token in the Integrations section of your Organization.

Some more detailed information is available here: https://developer.pagerduty.com/docs/events-api-v2/trigger-events/

### REST

#### Trigger Event
```
{
  "summary": "Critical credentials theft alert.",
  "source": "limacharlie.io",
  "severity": "critical",
  "component": "dr-creds-theft",
  "group": "lc-alerts",
  "class": "dr-rules"
}
```
