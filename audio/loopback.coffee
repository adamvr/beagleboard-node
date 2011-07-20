cp = require 'child_process'
util = require 'util'

args = ['-f', 'S16_LE', '-r', '44100', '-c1']

aplay = cp.spawn 'aplay', args
arecord = cp.spawn 'arecord', args

log = (msg) ->
    util.log msg

aplay.on 'exit', () -> log 'aplay exiting'
arecord.on 'exit', () -> log 'arecord exiting'
aplay.stderr.on 'data', (data) -> log "aplay:#{data}"
arecord.stderr.on 'data', (data) -> log "arecord:#{data}"

arecord.stdout.on 'data', (data) ->
    aplay.stdin.write data

