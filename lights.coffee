express = require 'express'
fs = require 'fs'

app = express.createServer()
app.use express.bodyParser()
app.use express.logger()

isJson = (req, res, next) ->
    if req.is 'application/json' then next() else next 'not json'

led = (req, res, next) ->
    light = req.params?.num
    if light not in ['0','1']
        next 'invalid light'
    else
        req.led = "/sys/class/leds/beagleboard::usr#{light}/"
        next()

mode = (req, res, next) ->
    mode = req.body?.mode
    if mode not in ['off', 'heartbeat', 'on']
        next 'invalid mode'
    else
        req.mode = mode
        next()

setMode = (led, mode, cb) ->
    switch mode
        when 'on'
            fs.writeFileSync "#{led}/brightness", 1
            fs.writeFileSync "#{led}/trigger", 'none'
        when 'off'
            fs.writeFileSync "#{led}/brightness", 0
            fs.writeFileSync "#{led}/trigger", 'none'
        when 'heartbeat'
            fs.writeFileSync "#{led}/trigger", 'heartbeat'
    cb()

app.post '/light/:num', isJson, led, mode, (req, res) ->
    setMode req.led, req.mode, (err) ->
        res.send if err? then err else 200

app.listen 3000
