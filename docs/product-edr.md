# Endpoint Detection & Response (EDR)

LimaCharlie’s EDR capability centralizes the collection of historic and real-time [event data](./events.md) in a common data format.

An infrastructure and API-first approach means that you can build what you need or choose to subscribe to a turnkey solution.

## Architecture & OS Support

 The agent is written in C and then compiled for each different platform and architecture it runs on which means that the sensor has true feature parity across all operating systems. The only exceptions are platform specific functions, such as monitoring Windows registry operations, etc. 

Various builds of the agent can run on the following for x86, ARM & MIPS architectures.

 * 32-bit Windows all way Back to Windows XP through to the most modern version of 64-bit Windows
 * All flavours of Linux both 32-bit and 64-bit 
 MacOS
 * Builds for Solaris and BSD can be produced on [request](https://limacharlie.io/user-ticket)
 
 LimaCharlie also provides a seperate agent for ChromeOS that can run stand alone or as a side-care to the main agent.

## Technical Specs

The agent is approximately 500kb in size but that varies a little depending on which platform it is compiled for. While running it consumes less that 1% CPU but does spike very briefly when certain events take place like an application starting up. LimaCharlie is able to pack so much power into such a small program because it treats the agent as an extension of the cloud by utilizing a true real-time persistent TLS connection. The round trip time from an event being detected to the time a response is actioned on the endpoint is generally less than 100 milliseconds.

Documentation on deploying the agent can be [found here](./deploy_sensor.md).

The LimaCharlie agent installs a sensor which is fully interactive and can monitor over [70 different event types](./events.md).

## Telemetry & Retention
 
Telemetry sent to the LimaCharlie is based on [events](./events.md) and is stored in its entirety in a one-year rolling buffer.

Telemetry uses the concept of [atoms](./events.md#atoms) and fine-grained control over what telemetry is sent up to the cloud can be managed using [exfil control](#exfil-control).

## Outputs



## Installing the Agent

Installing the sensor requires administrator (or root) execution:

**Windows EXE:** ```installer.exe -i YOUR_INSTALLATION_KEY```

**Windows MSI:** ```installer.msi WRAPPED_ARGUMENTS="YOUR_INSTALLATION_KEY"```

**MacOS:** ```chmod +x installer ; installer -i YOUR_INSTALLATION_KEY```

**Linux:** ```chmod +x installer ; installer -d YOUR_INSTALLATION_KEY```

**Note:** On Linux the exact persistence mechanism, like launchd, is left to the administrator, therefore the ```-d``` argument launches the sensor from the current working directory without persistence. The sensor does not daemonize itself.

**Note:** A sample installer script is [available here](https://github.com/refractionPOINT/lce_doc/blob/master/docs/lc_linux_installer.sh) that works on Debian and CentOS families.

**Chrome(+OS):** See our [documentation here]()


**Docker:** See our [documentation here]()

## Connectivity

**Agent to cloud:** agents require accesss over port 443 using pinned SSL certificates (SSL interception is not supported)
0651b4f82df0a29c.lc.limacharlie.io

**Chrome Agent to cloud:** agents require accesss over port 443 using normal SSL certificates websockets
0651b4f82df0a29c.wss.limacharlie.io

**Artifact Collection ingestion:** agents require accesss over port 443 to ingest artifact
0651b4f82df0a29c.ingest.limacharlie.io

**Replay API:** agents do NOT require access
0651b4f82df0a29c.replay.limacharlie.io

## <span style="color:#3889c7">Updating Sensor Versions</span>

Upgrading sensors is done transparently when the user clicks a button in the web application or through the API/SDK/CLI. Rolling back sensor versions can also be done with the click of a button in the web application or through the API/SDK/CLI. You do not need to re-download installers (in fact the installer stays the same). Once an upgrade has been triggered the new version should be in effect across the organization within about 20 minutes.

<!-- ![image 'Sensor Upgrade'](./images/sc-upgrade-sensor.png) -->

## <span style="color:#3889c7">ARM Variants</span>

Deploying on ARM can sometimes be tricky. The various architectures and naming can be confusing. To help you with this
here are the cross-compiling toolchains used for the various ARM variants LimaCharlie supports:

**arm:** gcc-arm-linux-gnueabihf

**arm64:** gcc-aarch64-linux-gnu

**arml:** gcc-arm-linux-gnueabi

If you are targeting Raspberry Pi you likely want `arml`.

## <span style="color:#3889c7">Installer Downloads</span>

**Windows**

[Windows 32 bit](https://app.limacharlie.io/get/windows/32)

[Windows 64 bit](https://app.limacharlie.io/get/windows/64)

[Windows msi32](https://app.limacharlie.io/get/windows/msi32)

[Windows msi64](https://app.limacharlie.io/get/windows/msi64)

**MacOS**

[MacOS 64 bit](https://app.limacharlie.io/get/mac/64)

[MacOS pkg](https://app.limacharlie.io/get/mac/pkg)

**Linux**

[Linux 32 bit](https://app.limacharlie.io/get/linux/32)

[Linux 64 bit](https://app.limacharlie.io/get/linux/64)

[Linux alpine64](https://app.limacharlie.io/get/linux/alpine64)

[Linux arm32](https://app.limacharlie.io/get/linux/arm32)

[Linux arm64](https://app.limacharlie.io/get/linux/arm64)

[Linux arml](https://app.limacharlie.io/get/linux/arml)

[Docker](https://hub.docker.com/r/refractionpoint/limacharlie_sensor)

**Chrome/ChromeOS** 

[Chrome](https://app.limacharlie.io/get/chrome/)
