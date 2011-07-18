cp = require 'child_process'
util = require 'util'
fs = require 'fs'

aplay = cp.spawn 'aplay'

log = (data) -> util.log data

aplay.on 'exit', () ->
    util.log 'aplay exiting'

aplay.stdout.on 'data', log
aplay.stderr.on 'data', log
    
fs.readFile "#{__dirname}/test.raw", (err, data) ->
    aplay.stdin.write data unless err
