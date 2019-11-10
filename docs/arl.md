# Authenticated Resource Locator

[TOC]

## Overview

Many features in LimaCharlie require access to external
resources, sometimes authenticated, provided by users.

Authenticted Resource Locators (ARNs) describe a way to
specify access to a remote resource, supporting many
methods, and including auth data, and all that within
a single string.

## Format

The structure of an ARN is simple:

With authentication:
```
[methodName,methodDest,authType,authData]
```

Without authentication:
```
[methodName,methodDest]
```

* methodName: the transport to use, one of `http`, `https`, `gcs` and `github`.
* methodDest: the actual destination of the transport. A domain and
path for HTTP(S) and a bucket name and path for GCS.
* authType: how to authenticate, one of `basic`, `bearer`, `token`, `gaia` or `otx`.
* authData: the auth data, like `username:password` for `basic`, or access token values.
If the value is a complex structure, like a `gaia` JSON service key, it must be
base64-encoded.

## Examples

HTTP GET with Basic Auth: `[https,my.corpwebsite.com/resourdata,basic,myusername:mypassword]`

Access using Authentication bearer: `[https,my.corpwebsite.com/resourdata,bearer,bfuihferhf8erh7ubhfey7g3y4bfurbfhrb]`

Access using Authentication token: `[https,my.corpwebsite.com/resourdata,token,bfuihferhf8erh7ubhfey7g3y4bfurbfhrb]`

Google Cloud Storage: `[gcs,my-bucket-name/some-blob-prefix,gaia,base64(GCP_SERVICE_KEY)]`

An OTX Pulse via the REST API: `[https,otx.alienvault.com/api/v1/pulses/5dc56c60a9edbde72dd5d013,otx,9uhr438uhf4h4u9fj7f6the8h383v8jv4ccc1e263d37f29d034d]`

Files in a Github repo's subdirectory using a Github Personal Access Token: `[github,myGithubUserOrOrg/repoName/optional/subpath/to,token,f1eb898f20a0db07e88878aadfsdfdfsffdsdfadwq8f767a72218f2]`

You can also omit the auth components to just describe a method: `[https,my.corpwebsite.com/resourdata]`
