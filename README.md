[![Join us on Discord](https://img.shields.io/discord/588772895870943302?label=join%20us%20on%20discord&logo=discord&style=flat-square)](https://discord.gg/TxPG97U)
[![Version](https://www.forgebox.io/api/v1/entry/nerdvision/badges/version)](https://www.forgebox.io/view/nerdvision)
[![Downloads](https://www.forgebox.io/api/v1/entry/nerdvision/badges/downloads)](https://www.forgebox.io/view/nerdvision)
[![Maven Central](https://img.shields.io/maven-central/v/com.nerdvision/agent.svg?label=Maven%20Central&style=flat-square)](https://search.maven.org/search?q=g:%22com.nerdvision%22%20AND%20a:%22agent%22)
# nerdvision-commandbox

This module adds support to enable [nerd.vision](https://nerd.vision) on the servers you start inside [CommandBox](https://commandbox.ortusbooks.com).

## Installation

````
box install nerdvision
````

## Configuration

The module has the following configuration properties:

| Name   | Required | Default Value 
|--------|:--------:|:-------------|
| apikey | yes      |              |
| version| no       | LATEST       |
| name   | no       | hostname     |
| tags   | no       |              |
| enable | no       | true         |

You can set an apikey to the nerd.vision module like so:

````
box config set modules.nerdvision.apikey=<your api key>
````

Set the other properties in the same way as required, e.g.

````
box config set modules.nerdvision.version=2.0.4
box config set modules.nerdvision.name="My nerd.vision App"
box config set modules.nerdvision.tags="foo=bar; level=42"
````

### box.json
Add nerdvision to your `box.json` as a dependency to ensure that the module is installed.

```json
{
  "dependencies":{
    "coldbox":"^6.4.0+1513",
    "nerdvision":"1.0.5"
  }
}
```

### server.json
To use this module with `server.json` you can add the following to the root of the file:

```json
{
  "nerdvision": {
    "apikey": "${NV_API_KEY}",
    "name": "${NV_NAME:commandbox}",
    "tags": "${NV_TAGS:''}"
  }
}
```

## Usage

After having set at least an apikey the nerd.vision agent will be downloaded and added to your server when you start the server with

````
box server start
````

The download will only be done if the nerdvision.jar file cannot be found in the expected location.

Once you server is running login to [nerd.vision](https://app.nerd.vision) and add a workspace for you application. Visit the [nerd.vision - Docs](https://docs.nerd.vision) site for additional information.

## Uninstall

The module does currently not provide logic to automatically uninstall nerd.vision from your server. To do this manually open your CommandBox servers.json file find the JVMArgs property and 
- delete the nv/ directory inside your server home directory as shown in the JVMargs value 
- remove the nerd.vision agent configuration from the JVMargs

The same steps are required if you want to change to a different version of nerd.vision. 

## Support

To get support using nerdvision or the commandbox module please contact nerd.vision via email (support@nerd.vision) or join us on [Discord](https://discord.gg/TxPG97U).
