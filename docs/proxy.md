# Proxy Support

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

Also on Windows, in some cases the environment variable changes do not propagate to all processes in the expected way.
Usually a reboot of the machine will fix it, but for machines that cannot be rebooted you have the ability to set a
special value to the environment variable (deletion is usually problematic but setting a var works) that will disable
the proxy specifically: `!`. So if you set the `LC_PROXY` variable to `!` (exclamation mark), the proxy will be disabled.