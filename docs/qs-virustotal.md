# Setting up the VirusTotal Integration

LimaCharlie also offers an integration with VirusTotal. If you do not already have an account with VirusTotal, you will have to create one and get an API key.

Once you have created an account find the API key. 

![VirusTotal API Key](https://storage.googleapis.com/lc-edu/content/images/graphs/quickstart-first-integration-1.png)

The free tier of VirusTotal allows four lookups per minute via the API.

Note: LimaCharlie employs a global cache of all VirusTotal requests which should significantly reduce your costs if you are using VirusTotal at scale. VirusTotal requests are cached for 3 days. 

Once you have your VirusTotal API key you can add it to the integrations section of the LimaCharlie web app.

![Add your VirusTotal API Key](https://storage.googleapis.com/lc-edu/content/images/graphs/quickstart-first-integration-2.png)

Once you have entered your API key, you can then create a DR rule to let you know if there is a hit from VirusTotal on a file with more than two different engines saying it is bad.

```yaml
path: event/HASH
op: lookup
resource: 'lcr://api/vt'
event: CODE_IDENTITY
metadata_rules:
  path: /
  value: 2
  length of: true
  op: is greater than
```
Once again the response component of this rule is left up to the user to exercise.
