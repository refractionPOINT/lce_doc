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

* https://app.limacharlie.io/get/windows/32 for the Windows 32 bit installer
* https://app.limacharlie.io/get/windows/64 for the Windows 64 bit installer
* https://app.limacharlie.io/get/linux/64 for the Linux 64 bit installer
* https://app.limacharlie.io/get/linux/alpine64 for the Linux Apline 64 bit installer
* https://app.limacharlie.io/get/mac/64 for the MacOS 64 bit installer
* https://app.limacharlie.io/get/chrome for the Chrome extension

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

### Containers and Virtual Machines
The LimaCharlie sensor can be installed in template-based environments whether they're VMs or Containers.

The methodology is the same as described above, but you need to be careful to stage the sensor install properly in your templates.

The most common mistake is to install the sensor directly in the template, and then instantiate the rest of the infrastructure
from this template. This will result in "cloned sensors", sensors running using the same Sensor ID (SID) on different hosts/VMs/Containers.

If these occur, a [sensor_clone](events.md#sensor_clone) event will be generated as well as an error in your dashboard. If this happens you
have two choices:

1. Fix the installation process and re-deploy.
1. Run a de-duplication process with a Detection & Response rule [like this](dr.md#de-duplicate-cloned-sensors).

Preparing sensors to run properly from templates can be done in one of two ways:

1. Run the installer on the template, shut down the service and delete the "identity files".
1. Script the sensor installation process in the templating process.

For solution 1, the identity files you will want to remove are:

* Windows: `%windir%\system32\hcp*`
* Linux: depending on the install location of the sensor, the `hcp*` files like `/usr/local/hcp*`.
* MacOS: `/usr/local/hcp*`

For solution 2, you can start a simple shell script like this to fetch the installer and run it on first boot:

```bash
#! /bin/bash

# Create a directory where the install will live.
mkdir lc_sensor

# Set the permissions on the directory to be limited to root.
chown root:root ./lc_sensor
chmod 700 ./lc_sensor

# Installer the sensor from within the directory to it install to the CWD.
cd lc_sensor

# Use an environment variable containing the Installation Key.
# Write it to a temporary file to limit the exposure of the key.
echo $LC_SENSOR_INSTALLATION_KEY > lc_installation_key.txt

# Fetch the latest sensor installer from limacharlie.io.
wget -O lc_sensor_64 https://app.limacharlie.io/get/linux/alpine64

# Limit permissions to the sensor.

# Run the sensor.
chmod 500 ./lc_sensor_64
./lc_sensor_64 -d - > /dev/null 2>&1 &

# Remove the Installation Key from the environment.
unset LC_SENSOR_INSTALLATION_KEY

# We started the sensor detached, so we give it a few seconds to read
# the Installation Key we put on disk before deleting it.
sleep 2
rm lc_installation_key.txt

cd ..
```

### Chrome
The Chrome sensor is currently shipped as an extension you must install locally. The Chrome Web Store support is coming.

1. In the LimaCharlie web app (app.limacharlie.io), go to the "Installation Keys" section, select your installation key and click the "Chrome Key" copy icon to
copy the key to your clipboard.
1. Download the sensor from: https://app.limacharlie.io/get/chrome
1. Then follow the instructions found in Method 2 here: https://blog.hunter.io/how-to-install-a-chrome-extension-without-using-the-chrome-web-store-31902c780034
1. From the Extensions page at chrome://extensions/ click on the "Details" button of the LimaCharlie Sensor extension.
1. Go to the "Extension options" section, and enter your installation key from the previous step. Click save.
1. Give it a minute and you should see your sensor showing up in your organization.

# Uninstalling the Sensor
Using an installer, as administrator / root, simply invoke it with one of:

`-r` to remove the sensor but leave in place the identity files. This means that although the sensor is no longer running, 
re-running an installer will re-use the previous sensor config (where to connect, sensor id etc) instead of creating a new one.

`-c` to remove EVERYTHING. This means that after a `-c`, the previous sensor's identity is no longer recoverable. Installing a
new sensor on the same host will result in a brand new sensor registering with the cloud.
