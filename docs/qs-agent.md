
# Installing the Agent

Before we can start leveraging the capabilities available in LimaCharlie, we have to get up and running first. This section guides the user through set up with an agent running on an endpoint.

The first step is to [create an account and your first Organization](https://www.youtube.com/watch?v=9icgkpYAoyA  ).

## Organization View

From the Organizational View navigate to the Install Sensors menu item in the lower portion of the main menu.

## Getting an Installation Key

To get started you will need to create an installation key. They can be created by visiting the Installation Keys section of the web application and clicking on the plus icon in the upper right corner.

![Create an Installation Key](https://storage.googleapis.com/lc-edu/content/images/content/qs-agent-1.png)

Once the key has been created, copy it to your clipboard. Next, visit the Sensor Downloads section of the web application and download the appropriate installer.

Once the sensor is downloaded to the endpoint you will need to give it the appropriate permissions and use the installation key when executing.

Installing the sensor requires administrator (or root) execution:

**Windows**: `installer.exe -i YOUR_INSTALLATION_KEY`

**MacOS**: `chmod +x installer ; installer -i YOUR_INSTALLATION_KEY`

**Linux**: `chmod +x installer ; installer -d YOUR_INSTALLATION_KEY`

**Note**: On Linux the exact persistence mechanism, like `launchd`, is left to the administrator. As a result, the `-d` argument launches the sensor from the current working directory without persistence. The sensor does not daemonize itself.

If you wish to remove the sensor from the endpoint you can do so by running the installer with the `-c` flag.

A sample script for setting up persistence on Linux systems that utilize init.d can be found here: [init.d](https://github.com/refractionPOINT/lce_doc/blob/master/docs/lc_linux_installer.sh)

A sample script for setting up persistence on Linux systems that utilize systemd can be found here: [systemd](https://github.com/refractionPOINT/lce_doc/blob/master/scripts/lc_systemd_installer.sh)

Once the sensor is installed it should show up in the Sensors section of the web application. To see the Sensor View for a specific endpoint click the hostname from this list.

![Sensor list](https://storage.googleapis.com/lc-edu/content/images/content/qs-agent-2.png)
