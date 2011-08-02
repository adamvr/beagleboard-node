express = require 'express'
util = require 'util'
sio = require 'socket.io'
fs = require 'child_process'

app = express.createServer()
app.use express.logger()
app.use express.bodyParser()
app.use express.static "#{__dirname}/public"

app.set 'view engine', 'coffeekup'
app.set 'view options', layout: false

app.get '/', (req, res) ->
    res.render 'index', title: 'Test'

manager = sio.listen app
manager.set 'log level', 2

random = manager.of '/random'
linear = manager.of '/linear'
cdata = [-25...25]

random.on 'connection', (socket) ->
    proc = fs.spawn 'cat', ['/dev/urandom']
    proc.stdout.on 'data', (data) ->
        nData = []
        for i in [0...50]
            nData[i] = data[i]
        random.emit 'data', nData
    socket.on 'disconnect', () ->
        proc.kill()
    

linear.on 'connection', (socket) ->
    interval = setInterval () ->
        linear.emit 'data', cdata
    , 100

    socket.on 'disconnect', () ->
        clearInterval interval

app.listen 3000
