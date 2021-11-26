# Add-ons

LimaCharlie's [add-ons marketplace](https://app.limacharlie.io/add-ons) can augment organizations with capabilities provided by LimaCharlie as well as other users in the community.


## Types of Add-ons

* `api` add-ons are tightly integrated add-ons that enable core LimaCharlie features
* `lookup` add-ons are lists of values usable in [rules](dr.md) to match known threat indicators
* `service` add-ons are cloud services that can perform jobs on behalf of an organization, or add new capabilities to an organization

Users can create their own add-ons privately which gives them access to enable those
rules in organizations they are members of, or publicly where anyone in the marketplace
can subscribe.

## Subscribing to Add-ons

Add-ons can be found and added to organizations through the [add-ons marketplace](https://app.limacharlie.io/add-ons) or by searching from within the Add-ons view in an organization. 

The description of the add-on should include usage information about how to use it once it's installed. Some services may add available options around the web application.

## Creating Add-ons

Users can create their own add-ons and optionally share them in the marketplace.

> To monetize an add-on of your own, reach out to us via [Slack](https://slack.limacharlie.io).

You can publish add-ons of your own from within the [Published add-ons](https://app.limacharlie.io/add-ons/published) view when logged in to the web application.

When making an add-on public, keep these in mind to ensure your add-on is understood and has a good chance at adoption:

* Fill in as many of the fields as possible.
* Make the purpose and usage of the add-on clear for users not aware of the capability.
* If the add-on requires a lot of background information, put it in the website link rather than the description.
* Your email address will be included in the add-on description. If you plan on publishing many rules, you may want to create a limacharlie.io account specifically for this purpose.
* The platforms flags are not enforced, but are a courtesy to the users to let them know where they can expect your add-on to work.
* Subscribers to your add-on will NOT have access to the exact implementation, this helps you protect specific Intellectual Property you may have, but it also means you need to be clear about the exact capabilities in your description and website.
* Add-ons remain your property, but may be evaluated and approved / dismissed due to quality or performance concerns. If you are not sure, contact us at support@limacharlie.io.
* If implementing a detection, include "filtering" of the relevant event types to what is strictly required for the detection, but avoid filtering on organization-defined labels as they change from organization to organization. If you do use labels, describe the exact usage in the description.
* Before making an add-on public, make sure to test it.

Creating an add-on does not immediately grant the organizations you're a member of access to it. After creating it, you must go in the organization you want to access it from, go to the Add-ons section and "subscribe" to your add-on. This will grant the organization access and then you can begin using it as part of D&R rules.

## Developer Grant Program

LimaCharlie is offering a $1000 in computation credits that can be applied towards using LimaCharlie to develop any kind of project you want. If you are looking to commercialize an idea we can help you get it into our marketplace and if there is traction there, we can further support you in growing.

Interested parties can apply for the grant program [here](https://limacharlie.io/grant-program).

## Next Steps

* Interested in creating a lookup? Check out [Lookups](lookups.md).
* Interested in writing a service? Check out [`lc-service`](https://github.com/refractionPOINT/lc-service) on GitHub.