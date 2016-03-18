request = require 'request'
jsdom = require 'jsdom'
jquery = require 'jquery'

UA = '''
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240
'''

# Pre-defined options
###
# query: The string to ask Google for
# num: Result numbers
# start: The ID of the first result
# lang: Search language
# exact: No auto-correction
# tld: Country-specific Google domain suffix.
#   e.g. 'co.uk' 'com.hk' 'co.jp'
###
optMap =
  query:
    dest: 'q'
    pre: encodeURIComponent
  num: 'num'
  start: 'start'
  lang: 'hl'
  exact:
    dest: 'nfpr'
    pre: (exact) -> if exact then 1 else 0
  tld:
    mod: (str, tld) -> str.replace 'google.com', "google.#{tld}"

exports.google = (options, callback) ->
  unless callback instanceof Function
    throw new Error 'Must provide a callback'

  # Can be called with 'google query, callback'
  options = query: options if typeof options is 'string'

  # Do not support empty queries
  unless options.query? and options.query.trim() isnt ''
    throw new Error 'Must provide a query string.'

  # Construct the query string
  url = 'https://www.google.com/search?'
  for k, v of options
    m = optMap[k]
    throw new Error "Invalid option #{k}" unless m?

    if m.mod?
      url = m.mod url, v
    else if m.pre?
      url += "#{m.dest}=#{m.pre v}&"
    else
      url += "#{m}=#{v}&"

  # Make the request
  request
    url: url
    headers:
      "User-Agent": UA
  , (err, res, body) ->
    callback err if err?

    jsdom.env body, (err, window) ->
      callback err if err?

      $ = jquery window
      results = []

      $('div.g').each ->
        title = $(@).find('h3').text()?.trim()
        content = $(@).find('div.s span.st').text()?.trim()
        unless !title? or !content? or title is '' or content is ''
          url = $(@).find('h3 a[target=_blank]').attr('href')
          if !url?
            url = $(@).find('h3 a').attr('href')
          results.push
            title: title
            content: content
            url: url

      callback null, results
