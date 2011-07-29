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

state =
    data: [i, Math.sin i] for i in [0..Math.PI * 2] by Math.PI/16
    curIndex: 0

setInterval () ->
    osco.emit 'data',
        index: state.curIndex
        data: state.data[state.curIndex]
    state.curIndex = (state.curIndex + 1) % state.data.length
, 250 


app.listen 3000
