# Use cases

This file is aimed to collect new detection ideas.

## Fractional Slash Domains
### Background on IDN Domains
IDN (Internationalised Domain Name) Homograph attacks entered main stream news back in Q2 2017. It was shown that domains could be registered using regular ASCII characters alongside characters from other languages to support domain names from countries with different character sets. This presented an issue as it meant that domains could be registered and characters could be swapped out for their doppelgangers (homographs), allowing anyone to register аррӏе.com (xn--80ak6aa92e.com) which almost certainly looks like apple.com
 
This becomes particularly dangerous when using ASCII characters with diacritics and substituting them e.g. twitter.com becomes ṭwitter.com. Note the small dot below the first ‘t’ which could easily be misinterpreted as a piece of dust.

### The fractional Slash
A fractional slash can be used to produce a domain that could be very confusing for phishing targets:
It's almost not possible to see the difference between
* ⁄ - Fractional slash
* / - Regular slash (not allowed in domain names)
 
The use of fractional slashes could have a target believe they are accessing a file on **their local machine** or network via their browser and could potentially dull their senses in spotting a phishing attempt.

To test this use case was enough to use a punycode converter to grab the punycode form of a fractional slash domain to thest via Whois record on Domain Tools, which obviously didn’t exist and simply shows the for sale banner: 
* https://whois.domaintools.com/xn--comdocumentdfrshlmn-706kiab.ml
* https://whois.domaintools.com/xn--cwindowssystem32-436iha.ml
