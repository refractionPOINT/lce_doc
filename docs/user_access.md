# User Access

To control who has access to an organization, and what they have access to, go
to the "Users" section of the web application.

Adding users is done by email address and requires the user to already have
a limacharlie.io account.

The first user of an organization is added with Owner permissions at creation time.
Owner permissions give full access to everything.

New users added after the creation of an orgnization are added with Unset privileges,
which means the user is only able to get the most basic information on the organization.

Therefore, the first step after adding a new user should always be to change their
permissions by clicking the Edit icon beside their name.

Permissions can be controlled individually, or you can apply pre-set permission
schemes by selecting it at the top of the dialog box, clicking Apply, and then
clicking the Save button at the bottom.

> For a full list of permissions, see [Reference: Permissions](permissions.md).

## Access via Groups

Groups allow you to grant permissions to a set of users on a group of organizations.

Permissions granted through the group are applied on top of permissions granted at the organization level. The permissions are additive, and a group cannot be used to subtract permissions granted at the organization level.

Group Owners are allowed to manage the Group, but are not affected by the permissions. Members are affected by the permissions but do not have the ability to modify the Group.