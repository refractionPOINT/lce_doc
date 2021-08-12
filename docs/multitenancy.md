# Multitenancy 

LimaCharlie is multi-tenant. It uses the concept of Organizations (tenants), Users, API Keys and Organization Groups.

## Organizations

This is an individual tenant (e.g. if you’re an MSSP, this would be one of your customers). All data generated underneath an Organization is tied to the given Organization.

Billing is performed per Organization.

## Users

Users are operators or administrators. Permissions are applied directly to the User account and allow for fine-grained access control.

Users have a many-to-many mapping with Organizations.

## API Keys 

An API Key represents a set of permissions and are used to interact with LimaCharlie. 

Full documentation on API Keys can be here.

## Organization Groups

Organization Groups provides a way for managing permissions for multiple Users across multiple Organizations.

An Organization Group has a set of permissions associated with it that are applied to all Users in the group. Permissions are additive.

Organization Groups drastically reduce the administration required and allows for fine-grained access control.