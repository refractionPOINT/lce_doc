***[Back to documentation root](README.md)***

# LCE Quick Start

{:toc}

This quick start guide will take you from you receiving your LCE cloud hosted credentials to having sensors enrolled and
seeing the data roll in.

## Getting Your Bearings
As part of your enrollment into the cloud hosted you should have received two pieces of information you will need.

The first is the domain name of your REST API endpoint. Although this endpoint is mainly used for REST call, it also
comes with some niceties which we will explore them a bit.

1. The root of the REST endpoint at `https://YOUR_API:8888/v1/`.
1. The REST API documentation is at `https://YOUR_API:8888/static/swagger/`.
1. Thin web UI is at `https://YOUR_API:8888/static/ui`.

The second bit of information is the master token used to gain access to the API. The master token is a secret value you
provide to the `/login` endpoint to mind a JWT token with a specific expiry and privileges that you then use with the API.

If this last bit sounds confusing it's ok, [here is a link](https://jwt.io/) to help give you some background on JWT, but
it won't be required for this quick start since we will use the thin web UI to do most of what we need to do.

## Logging In
The API, as mentioned earlier, also hosts a small single-page web app used over the REST interface. It makes for an easy
introduction to the concepts behind LCE while demonstrating the REST interface.

In your browser (main support is Chrome), go to `https://YOUR_API:8888/static/ui`. You will get a notification about
the website using a self-signed certificate.

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/1.png" width="150">
<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/2.png" width="150">

Although in the future this will be remedied, for now we recommend saving the
certificate as your trusted cert as [described here](http://www.nullalo.com/en/chrome-how-to-install-self-signed-ssl-certificates/).
This certificate is self-signed but will not ever change and is unique to your LCE instance.

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/3.png" width="150">

Once that is done, you should see a login prompt. There, enter `admin` as UserName, and your master token as password.
This will ask the REST interface for a token valid for 30 days that has access to read, write and all organizations.

Refreshing the web page should now result in you seeing a very simple dashboard indicating no sensors total and online.

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/4.png" width="150">

## Initial Organization
Click on the Profiles tab.

There you should see that 3 profiles have already been created for you. They are the default profiles which should be
a good sane default. These default, as set initially will apply to all organizations' sensors by default.
More details [here](profiles.md).

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/6.png" width="150">

Now click on the top left menu. In the side menu that opens, you should see a drop down menu named Organization. In there
you should see a default `Global` item (which sets the web ui to see only global information) and an item with the name
of your organization.

LCE supports multiple organizations, but by default one should have been created for you. You an delete it, or add new ones
to your liking, but the first one as been created to make it faster for you to be up and running. Select this organization.

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/5.png" width="150">

From this point, everything you see through the UI is from the perspective of this organization.

If you click on the Audit tab you should see an audit trail of everything that has changed in your organization. The 
Error tab will show any errors components have suffered. This Error tab will be especially useful when troubleshooting
new Outputs and D&R rules.

## Your First Sensor
Now the fun part.

### Getting Your Installation Key
Go to the Keys tab. You will now create your first installation key. At the bottom right, click on the `+` button. In the 
dialog that appears select your organization. Then optionally add comma separated tags that should be added to every
sensor that enrolls using that key, like "test". Finally give the key a description that will help you remember what it's
for, like "first installation key". Click the create button. The page will refresh and you should see your key.

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/7.png" width="150">

Click on the "copy to clipboard" icon for your key. If you paste the key you will see it looks something like this:

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/8.png" width="150">

```
AAAABgAAAQ4HAAABJjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALUtG10QNRt1Tpgwom+83L/j3lIk7HvdRC1Si+wz5Qaw4FQgOL7g39UfXLxtQZOZ+WuVeJ+SGUXMYiuIP22XgCZExj0E18PN5zG+xdSEoNCP2TtiA9uUc4QqgmosYQLCP5k5jsa1tyXwGkoI229KC/9wJOAS298MVPhfeaIzZR2IrdWXW+WnIOE5yCf26TeYZHQgReIVetIpkjY+YfNZRGQzAvQp8A6O4bBJFovN9767YuV/T1xW0fSVGC8zXKouAgjv5hghdd2p6o1HSHTZCC3zzyfTDSHs1B9ediZq+cq+LlB43b8KzaHctxVlNYbn39Ws1kjKMpxdUYgk0Zby+9UCAwEAAQAAARACAbsAAAERAgG7AAABCwUAAAAXdGVzdC5sYy5saW1hY2hhcmxpZS5pbwAAAAAIgQAAAAUAAAAJBwAAABAR70uWnexNzJOa3Q1irkSrAAAABQcAAAAQc3KM1fV8TB6GuIJtkIwywgAAAAQHAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAHAwAAAAAAAAAGAwAAAAAAAAEMBQAAABAxMzguMTk3LjEwNi4xODYA
```

This is an installation key, it describes where to reach your instance of LCE as well as a few cryptographic elements
used to confirm this sensor is authorized to enroll and that the LCE instance it is talking to is the real one.

### Downloading the Sensor
Open the top left menu, and from the side menu you should see links to then various supported sensor versions. Click on
the relevant one you'd like to install and download it.

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/9.png" width="150">

### Installing the Sensor
The following steps vary a bit per operating system.

#### MacOS and Windows
Both on MacOS and Windows, installing the sensor requires you to open a command prompt as administrator (or root on MacOS).

From there, launch the executable (on MacOS, you may need to `chmod a+x sensor_file` to make it executable) with the
command line argument `-i INSERT_YOUR_INSTALLATION_KEY_HERE`. This will install the sensor in such a way that it will
start at machine boot. You can then delete the sensor file (it has been copied to a permanent location).

#### Linux
The Linux story is a bit different. This is because although MacOS and Windows are fairly standard, Linux has a plethora
of different ways to install the sensor, and most organizations have their own flavor of installation. Therefore, in order
to make the sensor as easy as possible to adapt to all these installation methods, we've separated the installation from
running of the sensor.

Starting the sensor is done, as root, similarly to MacOS but uses the `-d INSERT_YOUR_INSTALLATION_KEY_HERE` command 
line argument instead. The sensor will use the `Current Working Directory` (***not the directory where the file is***)
as the installation directory where it stores the few files it needs to operate.

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/10.png" width="150">

So for example if the sensor is located on a shared drive called `/mnt/corp_shared/my_sensor`, and we wanted Linux sensors
to install in the `/etc/lc/` directory, we could make a small script that looks like this (and we run as root):

```shell
# Create the installation directory if it doesn't exist.
mkdir /etc/lc

# Make sure only root can access it.
chmod 700 /etc/lc

# Change directory to the install directory so it becomes our Current Working Directory.
cd /etc/lc

# Execute the sensor from our shared drive.
/mnt/corp_shared/my_sensor -d AAAABgAAAQ4HAAABJjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALUtG10QNRt1Tpgwom+83L/j3lIk7HvdRC1Si+wz5Qaw4FQgOL7g39UfXLxtQZOZ+WuVeJ+SGUXMYiuIP22XgCZExj0E18PN5zG+xdSEoNCP2TtiA9uUc4QqgmosYQLCP5k5jsa1tyXwGkoI229KC/9wJOAS298MVPhfeaIzZR2IrdWXW+WnIOE5yCf26TeYZHQgReIVetIpkjY+YfNZRGQzAvQp8A6O4bBJFovN9767YuV/T1xW0fSVGC8zXKouAgjv5hghdd2p6o1HSHTZCC3zzyfTDSHs1B9ediZq+cq+LlB43b8KzaHctxVlNYbn39Ws1kjKMpxdUYgk0Zby+9UCAwEAAQAAARACAbsAAAERAgG7AAABCwUAAAAXdGVzdC5sYy5saW1hY2hhcmxpZS5pbwAAAAAIgQAAAAUAAAAJBwAAABAR70uWnexNzJOa3Q1irkSrAAAABQcAAAAQc3KM1fV8TB6GuIJtkIwywgAAAAQHAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAHAwAAAAAAAAAGAwAAAAAAAAEMBQAAABAxMzguMTk3LjEwNi4xODYA
```

### Verify Enrollment
Give it a few seconds and go to the Sensor tab of the web UI. You should now see basic information on your sensor.

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/11.png" width="150">

If you don't see it there, have a look at the Error tab. Also confirm that the host where your sensor is running can
create connections outbound on port 443.

## Get the Data
The sensor is now connected to the LCE instance. LCE will manage the sensor and even execute the various D&R rules if you
had configured some. But the data won't be going anywhere yet.

LCE has two output streams that can be sent to any number of destinations using multiple methods. Let's configure one.

The two streams are Detections and Events. Detections is where any detection created by LCE through a D&R rule will be sent.
Often Security Operations Center (SOC) will want this to go to a system that they monitor for fast access like Splunk or Slack.

The second stream, Events, is where all the bulk events coming back from the sensors are going. Often times, SOCs will
send this bulk data towards a system that is better suited for longer term archival and searching like Splunk or ELK.

Go to the Output tab. No output should be configured by default, so click on the `+` button on the bottom right.

1. In the new dialog that opens, make sure your organization is selected. 
1. Give the output a human readable name that will help you remember what it is and where it is going.
1. Select one of the streams, Detections or Events.
1. Select an output module.

***This last step (seleting an output module) will vary depending on how you want the data forwarded. For the purpose of
this quick start guide, we will use Syslog, but feel free to use a different one as [documented here](outputs.md).***

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/12.png" width="150">

Since we're using Syslog, it means you need a system to receive the syslog data, any Syslog endpoint will do. It should
listen for Syslog over a TCP port of your chosing, with or without TLS encryption (although with is recommended).

The Syslog output takes two parameters (see the doc link above). So click twice on the small `+` button at the bottom
left of the dialog. Two blank parameter inputs will appear. On the left is the name of the parameter and on the right is
its value. Enter these two outputs:

1. `dest_host`: this is the IP or domain where the Syslog endpoint resides along with the port, like `10.1.1.42:514`.
1. `is_tls`: this is optional, but if set to `true` the data will be forwarded over TLS encryption.

When done, click the create button at the bottom right of the dialog.

<img src="https://lcio.nyc3.digitaloceanspaces.com/tutorial/13.png" width="150">

Depending on the type of output, sometimes the data will be buffered for a short period of time (less than 1 minute by default)
or it will be sent immediately (as is the case with Syslog). Give it a few minutes (your sensor may not be chatty) and
you should start seeing data arrive.

The data will be in JSON format. Some options for format are available, see the [doc](outputs.md).

## Next Steps
The next step is probably to start looking at [D&R rules](dr.md) as they are extremely powerful both for automation and sensor
management.
