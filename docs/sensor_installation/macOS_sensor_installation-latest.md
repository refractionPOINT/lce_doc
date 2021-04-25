# macOS Sensor (macOS 10.15 and macOS 11)

This document provides details of how to install, verify, and uninstall the LimaCharlie sensor on macOS (versions 10.15 and newer).  We also offer [documentation for macOS 10.14 and prior](macOS_sensor_installation-older.md).



<u>Table of Contents</u>

[Installation Flow](#Installation-Flow)

[Verifying the Installation](#Verifying-Installation)

[Uninstallation Flow](#Uninstallation-Flow)

[Installer Options](#Installer-Options)

[System Requirements](#System-Requirements)

[Using MDM Solutions](#Using-MDM-Solutions)

<a name="Installation-Flow"></a>

## Installation Flow

1. Download the [Sensor installer file](https://app.limacharlie.io/get/mac/64)



2. Add execute permission to the installer file via the command line

> chmod +x hcp_osx_x64_release_4.23.0



3. Run the installer via the command line.  You'll pass the argument -i and your installation key.

> sudo ./hcp_osx_x64_release_4.23.0 -i YOUR_INSTALLATION_KEY_GOES_HERE

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/01-Basic_installation.png" alt="Basic installation" style="zoom:100%;" />

You can obtain the installation key from the Installation Keys section of the LimaCharlie web application.  [More information about installation keys](https://doc.limacharlie.io/docs/documentation/docs/manage_keys.md).

The sensor will be installed as a launchctl service.  Installation will trigger the sensors enrollment with the LimaCharlie cloud.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/02-Installation_success.png" alt="Installation success" style="zoom:100%;" />

4. An application (RPHCP.app) will be installed in the /Applications folder and will automatically launch.  You will be prompted to grant permissions for system extensions to be installed.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/03-Permissions_Required.png" alt="Permissions required" style="zoom:50%;" />

5.  Click the "Open System Preferences" button

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/04-System_Extension_Required.png" alt="System Extensions Required" style="zoom:50%;" />

6.  Unlock the preference pane using the padlock in the bottom left corner, then click the Allow button next to `System software from application "RPHCP" was blocked from loading.`

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/06-Allow_System_Software_Unlocked.png" alt="Unlocked" style="zoom:50%;" />

7.  You'll be prompted to allow the application to Filter Network Content.  Click the Allow button.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/07--Network_Filter.png" alt="Network filter" style="zoom:50%;" />

8.  You'll be prompted to grant Full Disk Access.  Check the checkbox next to the RPHCP app in System Preferences -> Privacy -> Full Disk Access

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/08-Full_Disk_Access.png" alt="Full disk access" style="zoom:50%;" />

The installation is now complete and you should see a message indicating that the installation was successful.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/09-Success.png" alt="Success" style="zoom:50%;" />

<a name="Verifying-Installation"></a>
## Verifying Installation

To verify that the sensor was installed successfully, you can log into the LimaCharlie web application and see if the device has appeared in the Sensors section.  Additionally, you can check the following on the device itself:

In a Terminal, run the command:

> sudo launchctl list | grep com.refractionpoint.rphcp

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Verification/Verification-installation-successful.png" alt="Successful installation verification" style="zoom:100%;" />

If the agent is running, this command should return records as shown above.



You can also check the /Applications folder and launch the RPHCP.app.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/10-Applications.png" alt="Applications folder" style="zoom:100%;" />



The application will show a message to indicate if the required permissions have been granted.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Installation/11-App_Installed_Correctly.png" alt="App installed correctly" style="zoom:50%;" />

As described in the dialog, the RPHCP.app application must be left in the /Applications folder in order for it to continue operating properly.




### A note on permissions
Apple has purposely made installing extensions (like the ones used by LimaCharlie) a process that requires several clicks on macOS.  The net effect of this is that the first time the sensor is installed on a macOS system, permissions will need to be granted via System Preferences

Currently, the only way to automate the installation is to use an Apple-approved MDM solution. These solutions are often used by large organizations to manage their Mac fleet. If you are using such a solution, see your vendor's documentation on how to add extensions to the allow list which can be applied to your entire fleet.

We're aware this is an inconvenience and hope Apple will provide better solutions for security vendors in future.



<a name="Uninstallation-Flow"></a>
## Uninstallation Flow

To uninstall the sensor:

1. Run the installer via the command line.  You'll pass the argument -c

> sudo ./hcp_osx_x64_release_4.23.0 -c

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Uninstallation/1-Uninstall_Progress.png" alt="Uninstall progress" style="zoom:100%;" />

2. You will be prompted for credentials to modify system extensions.  Enteryour password and press OK.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Uninstallation/2-Uninstaller_Permissions.png" alt="Uninstall permissions" style="zoom:50%;" />

The related system extension will be removed and the RPHCP.app will be removed from the /Applications folder.



3.  You should see a message indicating that the uninstallation was successful.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Uninstallation/3-Uninstall_Success.png" alt="Uninstall success" style="zoom:100%;" />


<a name="Installer-Options"></a>
## Installer Options

When running the installer from the command line, you can pass the following arguments:

-v: display build version.

-q: quiet; do not display banner.

-d <INSTALLATION_KEY>: the installation key to use to enroll, no permanent installation.

-i <INSTALLATION_KEY>: install executable as a service with deployment key.

-r: uninstall executable as a service.

-c: uninstall executable as a service and delete identity files.

-w: executable is running as a macOS service.

-h: displays the list of accepted arguments.



<a name="System-Requirements"></a>
## System Requirements

**Supported OS' & Hardware**

- macOS version 10.9 to macOS 11 are supported
- Supported on both Intel (64-bit) and Apple Silicon based hardware 

<a name="Using-MDM-Solutions"></a>
## Using MDM Solutions

See our document <a href="./macOS-MDM-configuration-profile.md">macOS Agent Installation with MDM Solutions<a> for the Mobile Device Management (MDM) Configuration Profile that can be used to deploy the LimaCharlie agent to an enterprise fleet.