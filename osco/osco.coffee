express = require 'express'
util = require 'util'
sio = require 'socket.io'

app = express.createServer()
app.use express.logger()
app.use express.bodyParser()
app.use express.static "#{__dirname}/public"

app.set 'view engine', 'coffeekup'
app.set 'view options', layout: false

app.get '/', (req, res) ->
    res.render 'index', title: 'Test'

osco = (sio.listen app).of '/osco'

setInterval () ->
    min = 0
    max = 255
    res = []
    for i in [0..512]
        res.push [i, Math.floor((max-min) * Math.random() + min)]
    osco.emit 'data', val: res
, 250 


app.listen 3000
