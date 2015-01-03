#! ./node_modules/coffee-script/bin/coffee

Main entry point for the application.

    env = process.env['NODE_ENV'] || 'development'

Monitor with New Relic.

    require 'newrelic'

Create the express app.

    express = require 'express'
    app = express()

Compile and cache the html.

    jade = require 'jade'
    html = jade.renderFile './views/index.jade'

Compile and cache the css.

    less = require 'less'
    css = null

    fs = require 'fs'
    lessSrc = fs.readFileSync './views/index.less', 'utf8'

    less.render lessSrc, (err, result) ->
      if err then throw err
      css = result

Logging.

    logformat = if env is 'development' then 'dev' else 'default'
    app.use express.logger(logformat)

Serve static files.

    app.use express.static('./static')

Routes.

    app.get '/index.css', (req, res) ->
      res.contentType 'text/css'
      res.send css

    app.get '/', (req, res) ->
      res.send html

    port = process.env.PORT || 5000

    app.listen port, () ->
      console.log 'Server listening on port ' + port
