cp = require 'child_process'
aplay = cp.spawn 'aplay'

setInterval () ->
    buffer = new Buffer 40000
    for i in [0..40000]
        buffer[i] = Math.random() * 255

    aplay.stdin.write buffer
, 10000

