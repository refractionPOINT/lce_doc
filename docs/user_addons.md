# Add-ons

LimaCharlie's [add-ons marketplace](https://app.limacharlie.io/add-ons) can augment organizations with capabilities provided by LimaCharlie as well as other users in the community.


## Types of Add-ons

* `api` add-ons are tightly integrated add-ons that enable core LimaCharlie features
* `lookup` add-ons are lists of values usable in [rules](dr.md) to match known threat indicators
* `service` add-ons are cloud services that can perform jobs on behalf of an organization, or add new capabilities to an organization

## Subscribing to Add-ons

Add-ons can be found and added to organizations through the [add-ons marketplace](https://app.limacharlie.io/add-ons) or by searching from within the Add-ons view in an organization. The description of the add-on may include usage information about how to use it once it's installed.

The following add-ons enable additional functionality in the web application:

* [`atomic-red-team`](https://app.limacharlie.io/add-ons/detail/atomic-red-team) - scan Windows sensors right from their `Overview` page
* [`exfil`](https://app.limacharlie.io/add-ons/detail/exfil) - enables `Exfil Control` to configure which events should be collected per platform
* [`infrastructure-service`](https://app.limacharlie.io/add-ons/detail/infrastructure-service) - enable `Templates` in the UI to manage org config in `yaml`
* [`insight`](https://app.limacharlie.io/add-ons/detail/insight) - enables retention & browsing events and detections via `Timeline` and `Detections` 
* [`lc-net-install`](https://app.limacharlie.io/add-ons/detail/lc-net-install) - install Net sensors easily from the `Overview` page of Windows sensors 
* [`logging`](https://app.limacharlie.io/add-ons/detail/logging) - enables `Artifact Collection` to configure which paths to collect from
* [`net`](https://app.limacharlie.io/add-ons/detail/net) - adds `Net` sensor type and the ability to manage `Net Policies`
* [`replay`](https://app.limacharlie.io/add-ons/detail/replay) - adds a component next to D&R rules for testing them against known / historical events 
* [`responder`](https://app.limacharlie.io/add-ons/detail/responder) - sweep sensors right from their `Overview` page to find preliminary IoCs
* [`yara`](https://app.limacharlie.io/add-ons/detail/yara) - enables `YARA Scanners` view to pull in sources of YARA rules and automate scans with them

## Creating Add-ons

Users can create their own add-ons and optionally share them in the marketplace. Add-ons are your property, but may be evaluated and approved / dismissed due to quality or performance concerns. If you are not sure, contact us at support@limacharlie.io.

> To monetize an add-on of your own, reach out to us via [Slack](https://slack.limacharlie.io).

You can publish add-ons of your own from within the [Published add-ons](https://app.limacharlie.io/add-ons/published) view when logged in to the web application.

When making an add-on public, keep these in mind to ensure your add-on is understood and has a good chance at adoption:

* Test it!
* Make the purpose and usage of the add-on clear for users not aware of the capability.
* Include a link to more information if possible.
* Your email address will be included in the add-on description. If you plan on publishing many rules, you may want to create a separate account specifically for the purpose of being an add-on owner.

> Creating an add-on does not immediately grant the organizations you're a member of access to it. After creating it, you must still subscribe each organization to your add-on.

## Developer Grant Program

LimaCharlie is offering a $1,000 credit that can be applied towards using LimaCharlie to develop any kind of project you want. If you are looking to commercialize an idea we can help you get it into our marketplace and if there is traction there, we can further support you in growing.

Interested parties can apply for the grant program [here](https://limacharlie.io/grant-program).

## Next Steps

* Got / need a list of threat indicators? Check out [Lookups](lookups.md).
* Interested in writing a service? Check out the [`lc-service`](https://github.com/refractionPOINT/lc-service) frameworkon GitHub.
