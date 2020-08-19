# Proxy Support

[TOC]

## General
The LimaCharlie sensor supports unauthenticated proxy tunneling through [HTTP CONNECT](https://en.wikipedia.org/wiki/HTTP_tunnel).

This allows the LimaCharlie connection to go through the proxy in an opaque way (since the sensor does not support
SSL interception).

To activate this feature, set the `LC_PROXY` environment variable to the DNS or hostname of the proxy to use. For example
you could use: `LC_PROXY=proxy.corp.com:8080`.

## Windows
On Windows, you may use a light auto-detection of a globally-configured unauthenticatd proxy.

To enable this, set the same environment variable to the `-` value, like `LC_PROXY=-`. This will make the sensor query
the registry key `HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyServer` and use its
value as the proxy destination.