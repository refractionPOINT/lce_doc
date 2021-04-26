# macOS Agent Installation with MDM Solutions (macOS 10.15 and newer)

This document provides details of the Mobile Device Management (MDM) Configuration Profile that can be used to deploy the LimaCharlie agent to your enterprise fleet on macOS (versions 10.15 and newer).


<u>Table of Contents</u>

[Affected Dialogs](#Affected-Dialogs)

[Configuration Profile Details](#Configuration-Profile-Details)

[Example Jamf Pro Setup](#Example-Jamf-Pro-Setup)


<a name="Configuration-Profile-Details"></a>

## Affected Dialogs
Once the configuration profile is deployed using an approved MDM server, users will not need to provide approval to complete the agent installation.  In particular, the following three system approval dialogs will no longer be presented:

System Extension
<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/04-System_Extension_Required.png" alt="System Extensions Required" style="zoom:50%;" />

Network Filter
<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/07--Network_Filter.png" alt="Network filter" style="zoom:50%;" />

Full Disk Access
<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/08-Full_Disk_Access.png" alt="Full disk access" style="zoom:50%;" />


<a name="Configuration-Profile-Details"></a>

## Configuration Profile Details

We have provided a sample configuration profile for reference:  <a href="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/MDM_profiles/LimaCharlie.mobileconfig.zip"><img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/MDM_profiles/mobileconfig-icon.png" alt="MobileConfig icon" style="zoom:50%;" /></a>
<br>
<a href="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/MDM_profiles/LimaCharlie.mobileconfig.zip">
Download LimaCharlie.mobileconfig sample configuration profile
</a>

This profile includes the following permissions:
- System Extension
- Full Disk Access
- Network Content Filter


<a name="Example-Jamf-Pro-Setup"></a>

## Example Jamf Pro Setup

While any Apple / user approved MDM provider may be used, we have provided specific instructions for Jamf Pro as a matter of convenience.

1. Log into Jamf Pro and go to Computers -> Configuration Profiles

2. Add a new profile

3. In the General section choose a name for the profile and set Level to "Computer Level"

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/MDM_profiles/JamfPro-1-General.png" alt="System Extensions Required" style="zoom:50%;" />


4. Add a Privacy Preferences Policy Control configuration and set the parameters as follows:

Identifier:
com.refractionpoint.rphcp.extension

Identifier Type:
Bundle ID

Code Requirement:
anchor apple generic and identifier "com.refractionpoint.rphcp.extension" and (certificate leaf\[field.1.2.840.113635.100.6.1.9\] /* exists \*/ or certificate 1\[field.1.2.840.113635.100.6.2.6\] /\* exists \*/ and certificate leaf\[field.1.2.840.113635.100.6.1.13\] /\* exists \*/ and certificate leaf\[subject.OU\] = N7N82884NH)

App or Service:
SystemPolicyAllFiles

Access:
Allow

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/MDM_profiles/JamfPro-2-PPPC.png" alt="System Extensions Required" style="zoom:50%;" />


5. Add a System Extensions configuration and set the parameters as follows:

Enter your desired display name

System Extension Types:  Allowed System Extensions

Team Identifier:  N7N82884NH

Allowed System Extensions:  com.refractionpoint.rphcp.extension

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/MDM_profiles/JamfPro-2-SystemExtensions.png" alt="System Extensions Required" style="zoom:50%;" />


6. Add a Content Filter configuration and set the parameters as follows:

Enter your desired filter name

Identifier:  com.refractionpoint.rphcp.client

Filter Order:  Firewall

Add a Socket Filter with the following details:
Socket Filter Bundle Identifier:
com.refractionpoint.rphcp.client

Socket Filter Designated Requirement
anchor apple generic and identifier "com.refractionpoint.rphcp.client" and (certificate leaf\[field.1.2.840.113635.100.6.1.9\] /* exists \*/ or certificate 1\[field.1.2.840.113635.100.6.2.6\] /\* exists \*/ and certificate leaf\[field.1.2.840.113635.100.6.1.13\] /\* exists \*/ and certificate leaf\[subject.OU\] = N7N82884NH)

Add a Network Filter with the following details:

Network Filter Bundle Identifier:
com.refractionpoint.rphcp.client

Network Filter Designated Requirement:
anchor apple generic and identifier "com.refractionpoint.rphcp.client" and (certificate leaf\[field.1.2.840.113635.100.6.1.9\] /* exists \*/ or certificate 1\[field.1.2.840.113635.100.6.2.6\] /\* exists \*/ and certificate leaf\[field.1.2.840.113635.100.6.1.13\] /\* exists \*/ and certificate leaf\[subject.OU\] = N7N82884NH)


<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/MDM_profiles/JamfPro-4-ContentFilter.png" alt="System Extensions Required" style="zoom:50%;" />


7. Deploy the configuration profile to your devices.