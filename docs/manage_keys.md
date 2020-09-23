# Managing Installation Keys

Installation keys are the bits of text that you give to new sensors so that they may enroll properly in the organization you want.

## Components of an Installation Key
* OID: The Organization Id that this key should enroll into.
* IID: Installer Id that is generated and associated with every Installation Key.
* Tags: A list of Tags that get automatically applied to sensors enrolling with the key.
* Desc: The description used to help you differentiate uses of various keys.

## Common Scheme
Generally speaking, we use at least one Installation Key per organization. Then we use different keys to help
differentiate parts of our infrastructure. For example, you may create a key with Tag "server" that you will use
to install on your servers, a key with "vip" for executives in your organization, or a key with "sales" for the sales
department, etc. This way you can use the tags on various sensors to figure out different detection and response
rules for different types of hosts on your infrastructure.
