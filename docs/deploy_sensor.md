# Deploying Sensors

[TOC]

A machine-readable (YAML) link to the latest version of the LimaCharlie Enterprise sensor is [here](https://lcio.nyc3.digitaloceanspaces.com/sensors/index.yaml).

Direct links are also available from [LimaCharlie.io](https://limacharlie.io).

The sensor is signed and the same for everyone. The sensor's customization (who is the owner) is done at installation time
based on the [installation key](manage_keys.md) used. The installation key specifies where the sensor should connect
to enroll as well as the encryption key used to start the enrollment process.

Installing the sensor does not require a reboot. Also note that once installed the sensor does not have any visual components
so instructions on confirming it is installed and running are found below.

## Downloading the Sensors
To download the single installers relevant for your deployment, access the `/download/[platform]/[architecture]` control plane.
The `platform` component is one of `win`, `linux` or `osx` while the `architecture` component is either `32` or `64`.

For example:
* https://limacharlie.io/get/windows/32 for the Windows 32 bit installer
* https://limacharlie.io/get/windows/64 for the Windows 64 bit installer
* https://limacharlie.io/get/linux/64 for the Linux 64 bit installer
* https://limacharlie.io/get/mac/64 for the MacOS 64 bit installer

## Installing the Sensor
The sensors are designed to be simple to use and re-package for any deployment methodology you use in your organization.

The sensor requires administrative privileges to install. On Windows this means an Administrator or System account, on
MacOS and Linux it means the root account.

Before installing, you will need the [installation key](manage_keys.md) you want to use,

### Windows
Executing the installer via the command line, pass the `-i INSTALLATION_KEY` argument where `INSTALLATION_KEY` is the key
mentioned above. This will install the sensor as a Windows service and trigger its enrollment.

#### System Requirements
The LimaCharlie.io agent supports Windows XP 32 bit and up (32 and 64 bit). However, Windows XP and 2003 support is for the
more limited capabilities of the agent that do not require kernel support.

#### Checking it Runs
In an administrative command prompt issue the command `sc query rphcpsvc` and confirm the `STATE` displayed is `RUNNING`.

### MacOS
Executing the installer via the command line, pass the `-i INSTALLATION_KEY` argument where `INSTALLATION_KEY` is the key
mentioned above. This will install the sensor as a launchctl service and trigger its enrollment.

#### System Requirements
All versions of 64 bit macOS 10.9 and above are supported. If you need more, contact us.

#### Checking it Runs
In a Terminal, run the command `sudo launchctl list | grep com.refractionpoint.rphcp` which should return a single record with
the first column of the output being a number (a `-` indicates it is NOT running).

*Important Note*

On MacOS, Apple has recently made installing kernel extensions (as the one used by LimaCharlie) much harder. Unfortunately
this is ***entirely*** outside of our control. LC as well as many other vendors are affected by this.
The net effect of this is that the first time the sensor installs onto a MacOS system, a popup will appear asking the
user to go in the Security Control Panel and manually click on the button to approve the installation of the kernel
extension.

Currently, the only way to automate the installation of the extension is to use an Apple approved MDM solution. These
solutions are often used by large organizations to manage their Mac fleet. If you are using such a solution, see your
vendor's documentation on how to add a kernel extension as whitelisted to your entire fleet.

We're aware this is a big inconvenient and hopefully Apple will eventually provide a solution for security vendors.

### Linux
Executing the installer via the command line, pass the `-d INSTALLATION_KEY` argument where `INSTALLATION_KEY` is the key
mentioned above.

Because Linux supports a plethora of service management frameworks, by default the LC sensor does not
install itself onto the system. Rather it assumes the "current working directory" is the installation directory and 
immediately begins enrollment from there.

This means you can wrap the executable using the specific service management technology used within your organization by
simply specifying the location of the installer, the `-d INSTALLATION_KEY` parameter and making sure the current working
directory is the directory where you want the few sensor-related files written to disk to reside.

Common Linux packages may be available in the future.

A common methodology for Linux is to use `init.d`, if this sufficient for your needs, see this [sample install script](lc_linux_installer.sh).
You can invoke it like this:
```
sudo chmod +x ./lc_linux_installer.sh
sudo ./lc_linux_installer.sh <PATH_TO_LC_SENSOR> <YOUR_INSTALLATION_KEY>
```

#### System Requirements
All versions of Debian and CentOS starting around Debian 5 should be supported. Due to the high diversity of the ecosystem
it's also likely to be working on other distributions. If you need a specific platform contact us.

# Uninstalling the Sensor
Using an installer, as administrator / root, simply invoke it with one of:

`-r` to remove the sensor but leave in place the identity files. This means that although the sensor is no longer running, 
re-running an installer will re-use the previous sensor config (where to connect, sensor id etc) instead of creating a new one.

`-c` to remove EVERYTHING. This means that after a `-c`, the previous sensor's identity is no longer recoverable. Installing a
new sensor on the same host will result in a brand new sensor registering with the cloud.
