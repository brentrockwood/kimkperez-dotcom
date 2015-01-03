#! ./node_modules/coffee-script/bin/coffee

# Main entry point for the application.

This will be set to `production` in production.

    env = process.env['NODE_ENV'] || 'development'

Monitor with New Relic.

    require 'newrelic'

Create the express app.

    express = require 'express'
    app = express()

## Startup Compilation

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

## Miscellaneous Middleware

Logging.

    logformat = if env is 'development' then 'dev' else 'default'
    app.use express.logger(logformat)

Vanity server name.

    app.use (req, res, next) ->
      res.header 'X-powered-by', 'Brent Rockwood Software'
      next()

## Performance

Enable gzip compression.

    app.use express.compress()

Allow clients to cache for one day.

    app.use (req, res, next) ->
      ONE_DAY = 24 * 60 * 60 * 1000
      res.setHeader 'cache-control', 'public, max-age=' + ONE_DAY
      next()

    app.use (req, res, next) ->
      console.log req.headers
      next()

## Routes

Serve static files...

    app.use express.static('./static')

...and the css and html.

    app.get '/index.css', (req, res) ->
      res.contentType 'text/css'
      res.send css

    app.get '/', (req, res) ->
      res.send html

## Server Startup

    port = process.env.PORT || 5000

    app.listen port, () ->
      console.log 'Server listening on port ' + port
