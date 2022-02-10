# Deploying Sensors

The sensor is signed, and the same for everyone. The sensor's customization, which indicates the owner, is done at installation
based on the [installation key](manage_keys.md) used. The installation key specifies where the sensor should connect
to enroll, as well as the encryption key used to start the enrollment process.

Installing the sensor does not require a reboot. Also note that once installed, the sensor does not have any visual components,
so instructions on confirming it is installed and running are found below.

## Connectivity
The network connection required by the LimaCharlie sensor is very simple. It requires a single TCP connection over port
443 to a specific domain, and optionally another destination for the [Artifact Collection](external_logs.md) service.

The specific domains are listed in the Sensor Downloads section of your organization's dashboard. They will vary depending
on the datacenter you chose to create your organization in.

Currently, web proxies are not supported, but since LimaCharlie requires a single connection to a single dedicated domain, it
makes creating a single exception safe and easy.

## Downloading the Sensors
To download the single installers relevant for your deployment, access the `/download/[platform]/[architecture]` control plane.
The `platform` component is one of `win`, `linux` or `osx` while the `architecture` component is either `32` or `64`.

For example:

* https://downloads.limacharlie.io/sensor/windows/32 for the Windows 32 bit executable installer
* https://downloads.limacharlie.io/sensor/windows/64 for the Windows 64 bit executable installer
* https://downloads.limacharlie.io/sensor/windows/msi32 for the Windows 32 bit MSI installer
* https://downloads.limacharlie.io/sensor/windows/msi64 for the Windows 64 bit MSI installer
* https://downloads.limacharlie.io/sensor/linux/64 for the Linux 64 bit installer
* https://downloads.limacharlie.io/sensor/linux/alpine64 for the Linux Apline 64 bit installer
* https://downloads.limacharlie.io/sensor/linux/arm32 for the Linux ARM 32 bit installer
* https://downloads.limacharlie.io/sensor/linux/arm64 for the Linux ARM 64 bit installer
* https://downloads.limacharlie.io/sensor/mac/64 for the macOS 64 bit installer
* https://downloads.limacharlie.io/sensor/mac/arm64 for the macOS ARM 64 bit (Apple Silicon) installer
* https://downloads.limacharlie.io/sensor/chrome for the Chrome extension

## Installing the Sensor
The sensors are designed to be simple to use and re-package for any deployment methodology you use in your organization.

The sensor requires administrative privileges to install. On Windows this means an Administrator or System account, on
macOS and Linux it means the root account.

Before installing, you will need the [installation key](manage_keys.md) you want to use.

### Windows
Executing the installer via the command line, pass the `-i INSTALLATION_KEY` argument where `INSTALLATION_KEY` is the key
mentioned above. This will install the sensor as a Windows service and trigger its enrollment.

You may also install the Windows sensor using the MSI version. With the MSI, install using: `installer.msi InstallationKey="INSTALLATION_KEY"`.

You may also pass the value `-` instead of the `INSTALLATION_KEY` like: `-i -`. This will make the installer look for the
installation key in an alternate place in the following order:
* Environment variable `LC_INSTALLATION_KEY`
* Text file in current working directory: `lc_installation_key.txt`

#### System Requirements
The LimaCharlie.io agent supports Windows XP 32 bit and up (32 and 64 bit). However, Windows XP and 2003 support is for the
more limited capabilities of the agent that do not require kernel support.

#### Checking if it Runs
In an administrative command prompt issue the command `sc query rphcpsvc` and confirm the `STATE` displayed is `RUNNING`.

### macOS
Executing the installer via the command line, pass the `-i INSTALLATION_KEY` argument where `INSTALLATION_KEY` is the key
mentioned above.


[Step-by-step instructions for macOS 10.15 (Catalina) and newer](./sensor_installation/macOS_sensor_installation-latest.md)


[Step-by-step instructions for macOS 10.14 (Mojave) and older](./sensor_installation/macOS_sensor_installation-older.md)

You may also pass the value `-` instead of the `INSTALLATION_KEY` like: `-i -`. This will make the installer look for the
installation key in an alternate place in the following order:
* Environment variable `LC_INSTALLATION_KEY`
* Text file in current working directory: `lc_installation_key.txt`

### Linux
Executing the installer via the command line, pass the `-d INSTALLATION_KEY` argument where `INSTALLATION_KEY` is the key
mentioned above.

Because Linux supports a plethora of service management frameworks, by default the LC sensor does not
install itself onto the system. Rather it assumes the "current working directory" is the installation directory and 
immediately begins enrollment from there.

This means you can wrap the executable using the specific service management technology used within your organization by
simply specifying the location of the installer, the `-d INSTALLATION_KEY` parameter and making sure the current working
directory is the directory where you want the few sensor-related files written to disk to reside.

A common methodology for Linux is to use `init.d`, if this is sufficient for your needs, see this [sample install script](https://github.com/refractionPOINT/lce_doc/blob/master/docs/lc_linux_installer.sh).
You can invoke it like this:
```
sudo chmod +x ./lc_linux_installer.sh
sudo ./lc_linux_installer.sh <PATH_TO_LC_SENSOR> <YOUR_INSTALLATION_KEY>
```

You may also pass the value `-` instead of the `INSTALLATION_KEY` like: `-d -`. This will make the installer look for the
installation key in an alternate place in the following order:
* Environment variable `LC_INSTALLATION_KEY`
* Text file in current working directory: `lc_installation_key.txt`

#### Disabling Netlink
By default, the Linux sensor makes use of Netlink if it's availabe. In some rare configurations
this auto-detection may be unwanted and Netlink usage can be disabled by setting the
environment variable `DISABLE_NETLINK` to any value on the sensor process.

#### System Requirements
All versions of Debian and CentOS starting around Debian 5 should be supported. Due to the high diversity of the ecosystem
it's also likely to be working on other distributions. If you need a specific platform, contact us.

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
wget -O lc_sensor_64 https://downloads.limacharlie.io/sensor/linux/alpine64

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

#### Container Clusters
You can also run LimaCharlie at the host level in a container cluster system
like Kubernetes in order to monitor all running containers on the host with
a single sensor. In fact, this is the prefered method as it reduces the overhead
of running LC within every single container.

This is accomplished by a combination of a few techniques:

1. A privilged container running LC.
1. LC runs with `HOST_FS` environment variable pointing to the host's root filesystem mounted within the container.
1. LC runs with the `NET_NS` environment variable pointing to the host's directory listing network namespaces.
1. Running the container with the required flags to make sure it can have proper access.

The first step is straight forward. For example, set the environment like `ENV HOST_FS=/rootfs` and `ENV NET_NS=/netns` as part of your `Dockerfile`. This will let the LC sensor know where it can expect host-level information.

The second step is to run the container like: `docker run --privileged --net=host -v /:/rootfs:ro --env HOST_FS=/rootfs -v /var/run/docker/netns:/netns:ro --env NET_NS=/netns --env LC_INSTALLATION_KEY=your_key your-lc-container-name`.

Remember to pick the approriate LC sensor architecture installer for the *container* that will be running LC (not the host).
So if your privileged container runs Alpine Linux, use the `alpine64` version of LC.

A public version of the container described below is available from dockerhub as: `refractionpoint/limacharlie_sensor:latest`.

##### Sample Configurations
This is a sample `Dockerfile` you may use to run LC within a privileged container as described above:

```dockerfile
# Requires an LC_INSTALLATION_KEY environment variable
# specifying the installation key value.
# Requires a HOST_FS environment variable that specifies where
# the host's root filesystem is mounted within the container
# like "/rootfs".
# Requires a NET_NS environment variable that specific where
# the host's namespaces directory is mounted within the container
# like "/netns".
# Example:
# export ENV HOST_FS=/rootfs
# docker run --privileged --net=host -v /:/rootfs:ro -v /var/run/docker/netns:/netns:ro --env HOST_FS=/rootfs --env NET_NS=/netns --env LC_INSTALLATION_KEY=your_key refractionpoint/limacharlie_sensor

FROM alpine

RUN mkdir lc
WORKDIR /lc

RUN wget https://downloads.limacharlie.io/sensor/linux/alpine64 -O lc_sensor
RUN chmod 500 ./lc_sensor

CMD ./lc_sensor -d -
```

And this is a sample Kubernetes `deployment`:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: lc-sensor
  namespace: lc-monitoring
  labels:
    app: lc-monitoring
spec:
  minReadySeconds: 30
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  selector:
    matchLabels:
      app: lc-monitoring
  template:
    metadata:
      namespace: lc-monitoring
      labels:
        app: lc-monitoring
    spec:
      containers:
        - name: lc-sensor
          image: refractionpoint/limacharlie_sensor:latest
          imagePullPolicy: IfNotPresent
          securityContext:
            allowPrivilegeEscalation: true
            privileged: true
          resources:
            requests:
              memory: 80M
              cpu: 0.01
            limits:
              memory: 128M
              cpu: 0.9
          volumeMounts:
            - mountPath: /rootfs
              name: all-host-fs
            - mountPath: /netns
              name: all-host-ns
          env:
            - name: HOST_FS
              value: /rootfs
            - name: NET_NS
              value: /netns
            - name: LC_INSTALLATION_KEY
              value: <<<< YOUR INSTALLATION KEY GOES HERE >>>>
      volumes:
        - name: all-host-fs
          hostPath:
            path: /
        - name: all-host-ns
          hostPath:
            path: /var/run/docker/netns
      hostNetwork: true
```

#### SELinux
On some hardened versions of Linux, certain file paths are prevented from loading `.so` (Shared Object) files. LimaCharlie requires a location where
it can write `.so` files and load them. To enable this on hardened versions of Linux, you can specify a `LC_MOD_LOAD_LOC` environment variable containing
a path to a valid directory for loading, like `/lc` for example. This environment variable needs to be set for the sensor executable (`rphcp`) at runtime.

### Chrome
The Chrome sensor is available in the Chrome Web Store.

1. In the LimaCharlie web app (app.limacharlie.io), go to the "Installation Keys" section, select your installation key and click the "Chrome Key" copy icon to
copy the key to your clipboard.
1. Install the sensor from: [https://downloads.limacharlie.io/sensor/chrome](https://downloads.limacharlie.io/sensor/chrome)
1. A new tab will open where you can add your installation key from before. If you close it by mistake, you can re-open it by:
    1. From the Extensions page at chrome://extensions/ click on the "Details" button of the LimaCharlie Sensor extension.
    1. Go to the "Extension options" section, and enter your installation key from the previous step. Click save.

The installation key can also be pre-configured through the Managed Storage feature (key named `installation_key`) if you are using a managed Chrome deployment.

### Staging Deployment
When a new version of the sensor is made available, it can be useful to test the new version on specific hosts within an Organization without upgrading the whole Organization.

This can be achieved using a sensor tag called `latest`. When you tag a sensor with `latest`, the sensor version currently assigned to the Organization will be ignored for that
specific sensor and the latest version of the sensor will be used instead. This means you can tag a representative set of computers in the Organization with the `latest` tag in
order to test-deploy the latest version and confirm no negative effects.

# Uninstalling the Sensor
Using an installer, as administrator / root, simply invoke it with one of:

`-r` to remove the sensor but leave in place the identity files. This means that although the sensor is no longer running, 
re-running an installer will re-use the previous sensor config (where to connect, sensor id etc) instead of creating a new one.

`-c` to remove EVERYTHING. This means that after a `-c`, the previous sensor's identity is no longer recoverable. Installing a
new sensor on the same host will result in a brand new sensor registering with the cloud.
