# PagerDuty

## Overview
The PagerDuty service allows you to trigger events within PagerDuty. It requires
you to setup the PagerDuty access token in the Integrations section of your Organization.

Some more detailed information is available here: https://developer.pagerduty.com/docs/events-api-v2/trigger-events/

### REST

#### Trigger Event
```json
{
  "summary": "Critical credentials theft alert.",
  "source": "limacharlie.io",
  "severity": "critical",
  "component": "dr-creds-theft",
  "group": "lc-alerts",
  "class": "dr-rules"
}
```

### PagerDuty Configuration

On the PagerDuty side, you need to configure your service to receive the API notifications:

1. In your Service, go to the "Integrations" tab.
1. Click "Add a new integration".
1. Give it a name, like "LimaCharlie".
1. In the "Integration Type" section, select the radio button "Use our API directly" and select "Events API v2" from the dropdown.
1. Click "Add integration".
1. Back in the "Integrations" page, you should see your new integration in the list. Copy the "Integration Key" to your clipboard and add it in the "Integrations" section of LimaCharlie for PagerDuty.

From this point on, you may use a D&R rule to trigger a PagerDuty event. For example the following rule "response":

```yaml
- action: service request
  name: pagerduty
  request:
    group: lc-alerts
    severity: critical
    component: dr-creds-theft
    summary: Critical credentials theft alert.
    source: limacharlie.io
    class: dr-rules
```
