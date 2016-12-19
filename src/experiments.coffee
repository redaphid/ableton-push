_ = require 'lodash'
Ableton = require 'push-wrapper'
midi = require 'midi'

input = new midi.input()
output = new midi.output()

console.log input.getPortName 0
console.log output.getPortName 0
# output = access.output.values().next().value
# input = access.inputs.values().next().value

input.on 'message', (deltaTime, message) =>
  ableton.receive_midi message

input.openPort 0
output.openPort 0


ableton = new Ableton send: (bytes) -> output.sendMessage(bytes)

handlePush = ({x,y}) =>
  ableton.grid.x[x].y[y].led_rgb(255,0,0)
  ableton.grid.x[x].y[y].on 'pressed', (velocity) =>
    console.log {x,y, velocity}

for x in [1...9]
  for y in [1...9]
    handlePush({x,y})
