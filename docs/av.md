# Anti-Virus Integration

LimaCharlie offers integration to support existing Anti-Virus deployments.

## Microsoft Defender

The Windows LimaCharlie sensor can listen, alert, and automate based on various Defender events.

This is done through [listening for the Defender Event Log Source](https://doc.limacharlie.io/docs/documentation/docs/external_logs.md#from-real-time-events) and using [D&R rules](dr.md) to take the appropriate action.

A template to alert on the common Defender events of interest is available [here](https://github.com/refractionPOINT/templates/blob/master/anti-virus/windows-defender.yaml). The template can be used in conjunction with [Infrastructure As Code Service](https://doc.limacharlie.io/docs/documentation/docs/infrastructure-service.md) or its user interface in the [web app](https://app.limacharlie.io).

Specifically, the template alerts on the following Defender events:
* windows-defender-malware-detected (`event ID 1006`)
* windows-defender-history-deleted (`event ID 1013`)
* windows-defender-behavior-detected (`event ID 1015`)
* windows-defender-activity-detected (`event ID 1116`)
