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
manager.set 'log level', 1

osco = manager.of '/osco'
cdata = i for i in [0...50]

osco.on 'connection', (socket) ->
    random = fs.spawn 'cat', ['/dev/urandom']
    random.stdout.on 'data', (data) ->
        nData = []
        for i in [0...50]
            nData.push data[i]
        util.log util.inspect nData
        osco.emit 'data', nData

app.listen 3000
