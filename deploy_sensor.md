***[Back to documentation root](README.md)***

# Deploying Sensors

The latest version of the LimaCharlie sensor is available [here](https://lcio.nyc3.digitaloceanspaces.com/sensors/index.yaml).

The sensor is signed and the same for everyone. The sensor's home and keying is done at installation time based
on the [installation key](manage_keys.md) used. The installation key specifies where the sensor should connect
to enroll as well as the encryption key used to start the enrollment process.

## Downloading the Sensors
The latest sensor packs are available here: [https://github.com/refractionPOINT/limacharlie/releases/latest](https://github.com/refractionPOINT/limacharlie/releases/latest).

They contain the specialized executables used by the LCE backend to drive the sensors. It is the component referred 
to in the configuration `sensor_package`.

To download the single installers relevant for your deployment, access the `/download/[platform]/[architecture]` control plane.
The `platform` component is one of `win`, `linux` or `osx` while the `architecture` component is either `32` or `64`.

## Installing the Sensor
The sensors are designed to be simple to use and re-package for any deployment methodology you use in your organization.

The sensor requires administrative privileges to install. On Windows this means an Administrator or System account, on
MacOS and Linux it means the root account.

Before installing, you will need the [installation key](manage_keys.md) you want to use,

### Windows
Executing the installer via the command line, pass the `-i INSTALLATION_KEY` argument where `INSTALLATION_KEY` is the key
mentioned above. This will install the sensor as a Windows service and trigger its enrollment.

### MacOS
Executing the installer via the command line, pass the `-i INSTALLATION_KEY` argument where `INSTALLATION_KEY` is the key
mentioned above. This will install the sensor as a launchctl service and trigger its enrollment.

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
