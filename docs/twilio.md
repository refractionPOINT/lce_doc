# Twilio

## Overview
The Twilio service allows you to send messages within Twilio. It requires
you to setup the Twilio authentication in the Integrations section of your Organization.

Authentication in Twilio uses two components, a SID and a Token. The LimaCharlie Twilio
configuration combines both components in a single field like `SID/TOKEN`.

Some more detailed information is available here: https://www.twilio.com/docs/sms/send-messages

### REST

#### Send Message
```json
{
  "body": "Critical credentials theft alert.",
  "to": "+14443339999",
  "from": "+15551112222"
}
```
