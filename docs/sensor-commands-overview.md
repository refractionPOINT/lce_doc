
# Sensor Commands

Commands offer a safe way to interact with a sensor's host either for investigation, management, or threat mitigation purposes. 

> For a complete list of commands, see [Reference: Commands](sensor_commands.md).

## Sending Commands

There are a few options for sending commands to sensors:

* Manually using the Console of a sensor in the web application
* Manually using the [CLI](https://github.com/refractionPOINT/python-limacharlie)
* Programatically in the response action of a [Detection & Response rule](dr.md)
* Programatically using the [REST API](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI0OQ-task-sensor)

Regardless of which you choose, sent commands will be acknowledged immediately with an empty response, followed by a `CLOUD_NOTIFICATION` event being sent by the sensor. The content of command outputs are delivered as sensor events suffixed with `_REP`, depending on the command. 

This non-blocking approach makes responses accessible via the [event streams](sensors.md) passing through Detection & Response rules and Outputs.

## Structure

Commands follow typical CLI conventions using a mix of positional arguments and named optional arguments. 

Here's [`dir_list`](sensor_commands.md#dir_list) as an example:

```
dir_list [-h] [-d DEPTH] rootDir fileExp

positional arguments:
rootDir the root directory where to begin the listing from
fileExp a file name expression supporting basic wildcards like
* and ?

optional arguments:
-h, --help show this help message and exit
-d DEPTH, --depth DEPTH
optional maximum depth of the listing, defaults to a
single level
```

The Console in the web application will provide autocompletion hints of possible commands for a sensor and their parameters. For API users, commands and their usage details may be retrieved via the [`/tasks`](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI1OQ-get-possible-tasks) and [`/task`](https://doc.limacharlie.io/docs/api/b3A6MTk2NDI3OA-autocomplete-task) REST API endpoints.

## Investigation IDs

To assist in finding the responses more easily, you may specify an `investigation_id` (an arbitrary string) with a command. The response will then include that value under `routing/investigation_id`. Under the hood, this is exactly how the Console view in the web application works.

If an `investigation_id` is prefixed with `__` (double underscore) it will omit the resulting events from being forwarded to Outputs. This is primarily to allow Services to interact with sensors without spamming. 

## Command Line Format
When issuing commands to sensors as a command line (versus a list of tokens), the quoting and escaping of arguments can be confusing. This is a short explanation:

The command line tasks are parsed as if they were issued to a shell like `sh` or `cmd.exe` with a few tweaks to make it easier and more intuitive to use.

Arguments are parsed as separated by spaces, like: `dir_list /home/user *` is equal to 2 arguments: `/home/user` and `*`.

If an argument contains spaces, for example a single directory like `/file/my files`, you must use either single (`'`) or double (`"`) quotes around the argument, like: `dir_list "/files/my files"`.

A backslash (`\`), like in Windows file paths does not need to be escaped. It is only interpreted as an escape character when it is followed by a single or double quote.

The difference between single quotes and double quotes is that double quotes support escaping characters within using `\`, while single quotes never interpret `\` as an escape character. For example:
* `log_get --file "c:\\temp\\my dir\\" --type json` becomes `log_get`, `--file`, `c:\temp\my dir\`, `--type`, `json`
* `log_get --file 'c:\\temp\\my dir\\' --type json` becomes `log_get`, `--file`, `c:\\temp\\my dir\\`, `--type`, `json`
* `log_get --file 'c:\temp\my dir\' --type json` becomes `log_get`, `--file`, `c:\temp\my dir\`, `--type`, `json`
* `log_get --file "c:\temp\my dir\\" --type json` becomes `log_get`, `--file`, `c:\temp\my dir\`, `--type`, `json`

This means that as a general statement, unless you want to embed quoted strings within specific arguments, it is easier to use single quotes around arguments and not worry about escaping `\`.

## Going Deeper

* [Reference: Commands](sensor_commands.md)
* [Commands on Windows](sensors/windows.md)
* [Commands on Mac](sensors/mac.md)
* [Commands on Linux](sensors/linux.md)
* [Commands on Chrome](sensors/chrome.md)
* [Commands on Edge](sensors/edge.md)
