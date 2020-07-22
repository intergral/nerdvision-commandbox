# nerdvision-commandbox

**This is currently work in progress.**

This module adds support to enable [nerd.vision](https://nerd.vision) on the servers you start inside [CommandBox](https://commandbox.ortusbooks.com).

## Installation

### From a local directory
Install the module like so:

````
[box] install <path to nerdvision-commandbox folder>
````


## Configuration

The modules has the following configuration properties:

| Name   | Required | Default Value 
|--------|:--------:|:-------------|
| apikey | yes      |              |
| version| no       | LATEST       |
| name   | no       | hostname     |
| tags   | no       |              |

You can set an apikey to the nerd.vision module like so:

````
[box] config set modules.nerdvision.apikey=<your api key>
````

Set the other properties in the same way as required, e.g.

````
[box] config set modules.nerdvision.version=2.0.4
[box] config set modules.nerdvision.name="My nerd.vision App"
[box] config set modules.nerdvision.tags="foo=bar, level=42"
````

## Usage

After having set at least an apikey the nerd.vision agent will be downloaded and added to your server when you start the server with

````
[box] server start
````

Once you server is running login to [nerd.vision](https://app.nerd.vision) and add a workspace for you application. Visit the [nerd.vision - Docs](https://docs.nerd.vision) site for additional information.
