***[Back to documentation root](README.md)***

# Appliance Operations

* TOC
{:toc}

The LCE appliance is designed to operate either standalone or to cluster with other LCE appliances.

***If you're looking for how to setup a new cluster, see [this](new_cluster.md).***

## General Operations
Most operations of the LCE cluster can be done through the use of the appliance scripts that are symlinked
to the `/home/lc/` directory.

## Backup LCE
You can create a backup file that contains all configurations by using the `create_backup.py` script.
Do note that the backup generated does not include the stateful states, the key-value store or the HCP modules.
This means that when restoring on a new cluster (using the `restore_backup.py`) the first thing you will want to
do is to [`update_binaries`](new_org.md) in order to re-generate sensor binaries.

## Testing the Appliance
A "smoke test" can be run against an appliance. This test will create an organization, installation keys and other
features of LCE in order to exercise the basic functionality. All entities created will be destroyed at the end
of the test. To run it simply call the `test_appliance.py` script.

## Starting and Stopping Nodes
Nodes can only be started and stopped independently. However starting and stopping nodes is not a common activity since it
implies stopping the lower level Beach platform and not just the LCE software running on it. Therefore stopping and starting
should be considered a last resort action.

The two relevant scripts are `stop_node.py` and `start_node.py`. This performs a start of the current node as a normal node.
In contrast, you should have a single node running the "backend" which includes the "Control Plane" (REST multi site API).
Starting the node with the backend can be done either by running the `start_node.py` followed by the `start_backend.py` or
simply by calling the `start_all_in_one.py` script.

### Restarting Cluster Software
The recommended way of restarting the backend software is to use the `reload_component.py` script, which acts at the cluster
level (and not individual node). It allows you to specify for example: `reload_component.py c2` which triggers an unload
of all micro services on the cluster which then get reloaded automatically.

## Reloading Single Components
If for whatever reason you want/need/are instructed to restart a single component, this can be achieved without
any cluster downtime. For example, you may issue a `reload_component.py c2/endpoint --delay 60`. The `c2/endpoint` is the
component terminating the connections from sensors and where most of the complexity resides. The `--delay 60` indicates
that the component should be reloaded in a rolling-upgrade fashion (shutting down one instance every 60 seconds). All this
means that instances are being reloaded one at a time (other instances are always available).

## Issuing RPC Commands
The LCE backend is composed of multiple micro-services that we can send RPCs (Remote Procedure Calls) to. An RPC is the
combination of a destination service (like `c2/endpoint`), a command name (like `z`) and optional data (as a JSON dictionary).
The `z` command mentioned is a common command that all micro-services implement, it simply returns a dictionary of metrics
about the current execution of the micro-service.

Try it: `rpc.py c2/endpoint z --is-broadcast`. You should see a lot of metrics being printed to the screen. The 
`--is-broadcast` says that the RPC should be sent to *all* instances of that micro-service, not just one (the default).

## Removing Node From Cluster
If you intend on removing a node permanently from the cluster, use the `decommission_node.py` script. This will ensure
that any steps needed to leave the cluster in a clean way are taken.