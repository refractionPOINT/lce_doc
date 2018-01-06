***[Back to documentation root](README.md)***

# New Cluster

Some common terms used:
* Node: an instance of the appliance running as a virtual machine.
* Cluster: a collection of Nodes operating as a single unit.
* Site: an LCE Cluster running somewhere. Multi-site means multiple Clusters potentially running in completely different environments.
* Cassandra: the database technology used by the Cluster.
* Beach: the compute technology used by the Cluster.
* REST: an API technology based on HTTP as a communication method.
* Seed: an initial value used to bootstrap a process like joining a Cluster.

## Prerequirements

## Installing
1. Install python 2.7 if not already present.
1. Copy LCE over.
1. Make appliance with script: `./lce/infrastructure/appliance/make_scripts/make_lce_appliance.py`

Once the install process is finished, a new user `lc` is created and everything that follows is located
in that user's home directory (`/home/lc/`).

## Starting the Cluster
An LCE cluster is a collection of appliances connected to each other in order to provide high availability and 
scalability.

A core concept is the concept of `seed`. A `seed` node is a node of the cluster that used when a new node is started.
This new node requires a bootstrap, a node it knows how to connect to. Once that initial connection is done, the
full list of nodes will be shared and the new node becomes part of the cluster.

For this reason, you should specify a single `seed` node and generally ensure it stays online (although it is not special
during normal conditions when not bootstraping a new node).

For ourpurpose, we are assuming your first node will be your `seed` node and that you will be running the central
backend components (like the Control Plane) from there.

### For Seed Node
1. `init_cluster.py --interface eth1`
For a new cluster, this will initialize the database. The `interface` parameter specifies which network interface should
be used by Cassandra (Database) to communicate with the rest of the cluster. For example, if you had `eth0` to connect
to the internet and `eth1` as a private network interface, you would specify `eth1` here.

2. `python ./lce/control_plane/gen_creds.py somePasswordForAControlPlaneUser`
This will create a salted hash you will use in the next step for the Control Plane.

3. Copy creds to `vim ./lce/control_plane/sites.yaml`
Edit the `sites.yaml` file and set the salted hash you got from the previous step in the `credentials` section of the 
file. By default the user is called `admin` but you can change that if you want. Further access control may be added
in the future making multiple users with different privileges desirable.

4. Set the JWT secret in `vim ./lce/control_plane/sites.yaml`
The JWT secret is the secret key used when generating REST tokens for the Control Plane. Set the `jwt_secret` value
in the file to a long random string that you will keep secret.

5. `start_node.py --interface eth1`
By calling `start_node.py` we start the Beach service on this appliance. The `interface` parameter defines which network
interface will be used to listen on for other nodes.

6. `start_backend.py`
The `start_backend.py` command starts the collection of common helful services for the cluster. This includes:
  1. The Beach Dashboard which provides you with your cluster health at a glance through a web interface. Default port is `8080`.
  2. The Beach Patrol which takes care of monitoring for fallen actors in the Beach cluster and restarting them.
  3. The Control Plane which is the REST interface you can use to manage your LCE deployment (also supports multiple sites). Default port is `8888`.
  4. The Beach REST bridge which can be used to issue Beach RPCs over a generic REST interface. The Control Plane uses this to communicate with each site it connects to. Default port is `8889`.
As the backend starts, the Beach Patrol will request you input a password for the root key, a password for the c2 key and a password for the hbs keys.
These passwords are used to encrypt/decrypt those sensitive keys in the database. The passwords are not stored on disk
or in the database so that anyone gaining access to the database would not have easy access. You may alternatively
provide the `--no-key-passwords` argument to `start_backend.py` or `start_all_in_one.py` to use a blank password and skip
the prompt for password.


7. `./rpc.py c2/lcemanager init_backend`
The last step is to call the RPC for `init_backend` which generates the various cryptographic keys needed along with the 
default values used by the LCE backend.

### For Non-Seed Nodes
Once the first node has been created, adding new nodes is much easier.

1. `join_cluster.py --interface eth1 -a 192.168.1.1`
Calling `join_cluster.py` configures the new node to bootstrap by contacting an existing node. The `interface` parameter
specifies which network interface to use when contacting other nodes. The `-a` parameter is used to specify another
node as a `seed` node for this new node.

2. `start_node.py --interface eth1`
Finally we call `start_node.py` to start the Beach service, which in turns connects to the rest of the Cluster.

## Initial Configurations
Before creating organizations or enrolling sensors, there are a few configuration values you will want to set.

### Quick Start
Below are two small config files using the [simple config](simple_conf.md) mechanism. The first one will just define
all the basic attributes of your cluster:

```yaml
# File: main_config.yaml

# Main domain name the sensor will attempt to reach:
primary: lce1.mycompany.com
primary_port: 443

# Backup domain the sensor will contact:
secondary: lce2.mycompany.com
secondary_port: 443
```

Now load it: `./simpleconf.py --interface eth1 --load ./main_config.yaml`.

The second config defines organizations in one shot.

```yaml
# File: org_config.yaml

# This is a sample config file that can be loaded into an LCE backend and will create a
# single new org with a single new installation key.
# The 00000000-0000-0000-0000-000000000000 values will be replaced with new UUIDs automatically.

orgs:
    00000000-0000-0000-0000-000000000000:
        name: my_first_org
        installation_keys:
            00000000-0000-0000-0000-000000000000:
                tags:
                    - vip
                desc: installation key for executives
        outputs:
            test_out_events:
                for: event
                module: file
                dir: /tmp/lc_out_event/
            test_out_detecs:
                for: detect
                module: file
                dir: /tmp/lc_out_detect/
```

Now load it: `./simpleconf.py --interface eth1 --load ./org_config.yaml`.

Finally set the default [profiles](profiles.md) to apply to all sensors:
```shell
./rpc.py c2/hbsprofilemanager set_profile -d "{ 'aid' : '0.0.0.10000000.0', 'default_profile' : 'windows' }"
./rpc.py c2/hbsprofilemanager set_profile -d "{ 'aid' : '0.0.0.20000000.0', 'default_profile' : 'linux' }"
./rpc.py c2/hbsprofilemanager set_profile -d "{ 'aid' : '0.0.0.30000000.0', 'default_profile' : 'macos' }"
```

You're now good to go. Get the [installation key](manage_keys.md) you created and start [deploying sensors](deploy_sensor.md).

### Manual Way
Each of those configurations can be set either using a `POST` to the `/{site}/configs` endpoint of the Control Plane or
by issuing a RPC like this: `./rpc.py c2/deploymentmanager set_config -d "{ 'conf' : 'nameOfTheConfigToSet', 'value' : 'valueToSetTheConfigTo' }"`

* `global/primary`: this value is the primary domain or IP address the sensors will connect to.
* `global/primary_port`: this is the port associated with the primary destination above.
* `global/secondary`: this value is the secondary domain or IP address the sensors will connect to if the primary fails.
* `global/secondary_port`: this is the port associated with the secondary destination above.
* `global/paging_user`: this is the user name to authenticate with when sending emails via SMTP, leave blank if you don't want to send automated emails.
* `global/paging_from`: this is the "from" address to use with paging above.
* `global/paging_password`: this is the password to authenticate with the paging above.

You can now start [creating organizations](new_org.md) and [enrolling sensor](deploy_sensor.md).
