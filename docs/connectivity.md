**LimaCharlie Enterprise Only - Not LimaCharlie Cloud**

# Connectivity

[TOC]

## Default Appliance

### Endpoints
The LCE appliance, by default can operate as a connection point for the LC sensors on port 443 and 80. For larger deployments
the endpoint connectivity can be decoupled from the appliances by setting up TCP load balancers or using the LC reverse
proxy running on the appliance.

### Between Appliances
The LCE appliances cluster to each other through two main technologies, Cassandra for storage and Beach for compute. Because
the number of ports used by each is high, it is recommended to simply allow all connection between appliances.

## Management
If the cluster is started with the `start_all_in_one.py` or `start_backend.py`, more components will be started and
will require access.

### Beach Dashboard
This is a simple read-only dashboard providing visibility into the the components loaded, usage and queries-per-second
on Beach. This dashboard listens on port `8080` over HTTP and has no access control.

### Control Plane
The control plane is the multi-site REST interface. It is available on port `8888` over HTTPS (on self signed certificates
by default) at `/static/ui` for a basic web page over the REST interface, or at `/static/swagger` for the Swagger based
web documentation while the main REST endpoint is simply at `/v1/`.

### Appliance Beach REST
The control plane connects to LCE sites via the Beach REST bridge (which translates REST calls into RPCs internally). This
bridge listens on port `8889` over HTTPS. If you intend on using the control plane centrally connecting to multiple 
sites, this is the only connectivity between the control plane and the sites that is required.
