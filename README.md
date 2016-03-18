Googler in CoffeeScript
---
This is a port of the [googler](https://github.com/jarun/googler) program to Node.Js.

Written in CoffeeScript.

Installation
---
```
npm install googler-coffee
```

Usage
---
```coffeescript
{google} = require 'googler-coffee'

google 'query', (err, results) ->
  ...

google
  query: q
  num: 5
, (err, results) ->
  ...

# For more options, see the comments in src/googler.coffee
```

CLI
---
A CLI interface for Googler is also provided. First, make sure you have the `npm bin` directory in your path and install this module.

```
Usage: googler <query> [options]

Options:
  -l, --lang   Set the language for the results. e.g. en
  -n, --num    Number of results returned per page
  -s, --start  Start at the Nth result
  -c, --tld    Country-specific Google domain suffix. e.g com.hk co.uk
  -x, --exact  Turn off auto-correction [boolean]
  -h, --help   Print this information   [boolean]
```

CAPTCHA
---
I haven't come up with any solution yet. Please try to use IPv6 as IPv6 has a large amount of addresses.
