# macOS Sensor (macOS 10.14 and prior)

This document provides details of how to install, verify, and uninstall the LimaCharlie sensor on macOS (versions 10.14 and prior).  We also offer [documentation for macOS 10.15 and newer](macOS_sensor_installation-latest.md).



<u>Table of Contents</u>

[Installation Flow](#Installation-Flow)

[Verifying the installation](#Verifying-Installation)

[Uninstallation Flow](#Uninstallation-Flow)

[System Requirements](#System-Requirements)


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

4. You will be prompted to grant permissions for system extensions to be installed.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/macOS_10.14/03_Older_Systems-System_Extension_Notice.png" alt="Permissions required" style="zoom:50%;" />

5.  Click the "Open System Preferences" button



6.  Unlock the preference pane using the padlock in the bottom left corner, then click the Allow button next to `System software from developer "Refraction Point, Inc" was blocked from loading.`

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/macOS_10.14/04-Older_Systems-System_Software_Approval.png" alt="Unlocked" style="zoom:50%;" />

The installation is now complete and you should see a message indicating that the installation was successful.



<a name="Verifying-Installation"></a>
## Verifying Installation

To verify that the sensor was installed successfully, you can log into the LimaCharlie web application and see if the device has appeared in the Sensors section.  Additionally, you can check the following on the device itself:

**Ensure the process is running**

In a Terminal, run the command:

> sudo launchctl list | grep com.refractionpoint.rphcp

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/macOS_10.14/Installed_correctly.png" alt="Successful installation verification" style="zoom:50%;" />

If the agent is running, this command should return a record as shown above.



**Ensure the Kernel Extension is loaded**

You can confirm that the kernel extension is loaded by running the command:

> kextstat | grep com.refractionpoint.



<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/macOS_10.14/verifying-extension.png" alt="Successful installation verification" style="zoom:50%;" />

If the extension is loaded, this command should return a record as shown above.






### A note on permissions
Apple has purposely made installing extensions (like the ones used by LimaCharlie) a process that requires several clicks on macOS.  The net effect of this is that the first time the sensor is installed on a macOS system, permissions will need to be granted via System Preferences

Currently, the only way to automate the installation is to use an Apple-approved MDM solution. These solutions are often used by large organizations to manage their Mac fleet. If you are using such a solution, see your vendor's documentation on how to add extensions to the allow list which can be applied to your entire fleet.

We're aware this is an inconvenience and hope Apple will provide better solutions for security vendors in future.



<a name="Uninstallation-Flow"></a>
## Uninstallation Flow

To uninstall the sensor:

1. Run the installer via the command line.

You'll pass the argument -c

> sudo ./hcp_osx_x64_release_4.23.0 -c

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/macOS_10.14/Installed_correctly.png" alt="Uninstall progress" style="zoom:50%;" />

2. You should see a message indicating that the uninstallation was successful.

<img src="https://storage.googleapis.com/limacharlie-io/doc/sensor-installation/macOS/images/Uninstallation/3-Uninstall_Success.png" alt="Uninstall success" style="zoom:100%;" />

<a name="Installer-Options"></a>
## Installer Options

When running the installer from the command line, you can pass the following arguments:

-v: display build version.

-d <INSTALLATION_KEY>: the deployment key to use to enroll, no permanent installation.

-i <INSTALLATION_KEY>: install executable as a service with deployment key.

-r: uninstall executable as a service.

-c: uninstall executable as a service and delete identity files.

-w: executable is running as a macOS service.

-h: displays the list of accepted arguments.


<a name="System-Requirements"></a>
## System Requirements

- macOS version 10.9 to macOS 11 are supported
- Supported on both Intel (64-bit) and Apple Silicon based hardware 

