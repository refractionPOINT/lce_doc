# Access & Permissions

LimaCharlie is [multi-tenant](https://en.wikipedia.org/wiki/Multitenancy); tenants are called Organizations and both data and billing are tied to the Organization. 

Users, API Keys and Groups exist as ways of managing access and permissions to Organizations.

## Users

Users are operators or administrators. Permissions are applied directly to the User account and allow for fine-grained access control.

One user can be a member of multiple organizations.

## API Keys 

An API Key represents a set of permissions and are used to interact with LimaCharlie. 

Full documentation on API Keys can be [here](./api_keys.md).

## Groups

Groups provides a way for managing permissions for multiple Users across multiple Organizations.

Groups each have a set of permissions associated with them that are applied (additively) to all Users in the group, for all Organizations in the group. Groups drastically reduce the admin overhead in managing fine-grained access control.

More information [here](./user_access.md#access-management-via-organization-groups).
