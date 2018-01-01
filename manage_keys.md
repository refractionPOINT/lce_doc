# Managing Installation Keys
Installation keys are the bits of text that you give to new sensors so that they may enroll properly in the organization you want.

## Components of an Installation Key
* OID: The Organization Id that this key should enroll into.
* IID: Installer Id that is generated and associated with every Installation Key.
* Tags: A list of Tags that get automatically applied to sensors enrolling with the key.
* Desc: The description used to help you differentiate uses of various keys.

## Common Scheme
Generally speaking, we use at least one Installation Key per organization. Then we use different keys to help
differentiate parts of our infrastructure. For example, you may create a key with Tags "server" that you will use
to install on your servers. A key with "vip" for executives in your organization. A key with "sales" for the sales
department etc. This way you can use the tags on various sensors to figure out different detection and response
rules for different types of hosts on your infrastructure.

## Creating Keys
* REST: `POST` to the `/installationkeys/{oid}`
* RPC: `./rpc.py c2/enrollments add_installation_key -d "{ 'oid' : '00000000-0000-0000-0000-000000000000', 'desc' : 'Human description of that key usage.', 'tags' : [ 'vip', 'workstation' ] }"`

## Deleting Keys
* REST: `DELETE` to the `/installationkeys/{oid}`
* RPC: `./rpc.py c2/enrollments del_installation_key -d "{ 'oid' : '00000000-0000-0000-0000-000000000000', 'iid' : 00000000-0000-0000-0000-000000000000' }"`

## Listing Keys
* REST: `DELETE` to the `/installationkeys/{oid}`
* RPC: `./rpc.py c2/enrollments get_installation_key -d "{ 'oid' : '00000000-0000-0000-0000-000000000000' }"`
