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

osco = (sio.listen app).of '/osco'

osco.on 'connection', (socket) ->
    random = fs.spawn 'cat', ['/dev/random']
    random.stdout.setEncoding 'base64'
    random.stdout.on 'data', (data) ->
        nData = data[0...50]
        util.log nData
        osco.emit 'data', nData

app.listen 3000
