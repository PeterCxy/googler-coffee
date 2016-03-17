# Command-line interface for Googler
_ = require 'colors'
blessed = require 'blessed'
{google} = require './googler'
argv = require 'yargs'
  .alias 'l', 'lang'
  .describe 'l', 'Set the language for the results. e.g. en'
  .alias 'n', 'num'
  .describe 'n', 'Number of results returned per page'
  .alias 's', 'start'
  .describe 's', 'Start at the Nth result'
  .alias 'c', 'tld'
  .describe 'c', 'Country-specific Google domain suffix. e.g com.hk co.uk'
  .alias 'x', 'exact'
  .describe 'x', 'Turn off auto-correction'
  .boolean [ 'x' ]
  .demand 1
  .usage 'Usage: $0 <query> [options]'
  .help 'h'
  .alias 'h', 'help'
  .describe 'h', 'Print this information'
  .argv

# Build the options
options = query: argv._.join ' '
options.start = argv.start if argv.start?
options.num = argv.num if argv.num?
options.lang = argv.lang if argv.lang?
options.tld = argv.tld if argv.tld?
options.exact = argv.exact if argv.exact?

options.start = 0 if !options.start?
options.num = 10 if !options.num?

# Terminal preparations
screen = blessed.screen
  fullUnicode: yes
txtBox = blessed.box
  top: 0
  left: 0
  width: '100%'
  height: '100%-1'
  content: ''
  scrollable: yes
  alwaysScroll: yes
  keys: yes
screen.append txtBox
promptBox = blessed.box
  top: '100%-1'
  left: 0
  width: '100%'
  height: 1
  padding: 0
  content: 'Searching...'.black.bgWhite
screen.append promptBox
screen.key 'q', -> process.exit 0
screen.key 'n', ->
  options.start += options.num
  do g
screen.key 'p', ->
  options.start -= options.num if options.start >= options.num
  do g
txtBox.focus()
promptBox.setFront()
screen.render()

# Do Google!
g = ->
  promptBox.setContent 'Searching...'.bgWhite.black
  screen.render()
  google options, (err, res) ->
    throw err if err?

    # Build the output
    out = ''

    for r, i in res
      out += """
#{i + 1}. #{r.title.blue}
#{r.url.cyan}
#{r.content}
 """ + '\n\n'

    txtBox.setContent out
    promptBox.setContent "'q' to exit, 'n' for the next page and 'p' for the previous.".bgWhite.black
    screen.render()

do g
