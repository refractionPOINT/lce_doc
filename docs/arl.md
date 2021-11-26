# Authenticated Resource Locator

## Overview

Many features in LimaCharlie require access to external resources, sometimes authenticated, provided by users.

Authenticated Resource Locators (ARLs) describe a way to specify access to a remote resource, supporting many methods, including authentication data, and all that within a single string.

## Format

### With authentication

```
[methodName,methodDest,authType,authData]
```

### Without authentication

```
[methodName,methodDest]
```

* `methodName`: the transport to use, one of `http`, `https`, `gcs` and `github`.
* `methodDest`: the actual destination of the transport. A domain and path for HTTP(S) and a bucket name and path for GCS.
* `authType`: how to authenticate, one of `basic`, `bearer`, `token`, `gaia` or `otx`.
* `authData`: the auth data, like `username:password` for `basic`, or access token values. If the value is a complex structure, like a `gaia` JSON service key, it must be base64-encoded.

## Examples

### HTTP GET with no auth
`[https,my.corpwebsite.com/resourdata]`

### HTTP GET with basic auth

`[https,my.corpwebsite.com/resourdata,basic,myusername:mypassword]`

### HTTP GET with bearer auth

`[https,my.corpwebsite.com/resourdata,bearer,bfuihferhf8erh7ubhfey7g3y4bfurbfhrb]`

### HTTP GET with token auth

`[https,my.corpwebsite.com/resourdata,token,bfuihferhf8erh7ubhfey7g3y4bfurbfhrb]`

### Retrieve from Google Cloud Storage

`[gcs,my-bucket-name/some-blob-prefix,gaia,base64(GCP_SERVICE_KEY)]`

### Retrieve OTX Pulse via REST API

`[https,otx.alienvault.com/api/v1/pulses/5dc56c60a9edbde72dd5d013,otx,9uhr438uhf4h4u9fj7f6the8h383v8jv4ccc1e263d37f29d034d]`

### Retrieve from GitHub repo with Github Personal Access Token

`[github,myGithubUserOrOrg/repoName/optional/subpath/to,token,f1eb898f20a0db07e88878aadfsdfdfsffdsdfadwq8f767a72218f2]`

### Retrieve from public GitHub repo at a specific branch

`[github,refractionPOINT/sigma/some-sub-dir?ref=my-branch]`