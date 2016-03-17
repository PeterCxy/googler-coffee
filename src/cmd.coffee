require('./googler').google
  query: 'Python Googler'
  lang: 'en'
  exact: yes
  tld: 'co.uk'
, (err, res) ->
  console.log res
