_              = require 'lodash'
PushWrapper    = require 'push-wrapper'
midi           = require 'midi'
{EventEmitter} = require 'events'

class Ableton extends EventEmitter
  connect: () =>
    @midiInput = new midi.input()
    @midiOutput = new midi.output()

    @pushWrapper = new PushWrapper send: (bytes) => @midiOutput.sendMessage(bytes)

    @midiInput.on 'message', (deltaTime, message) =>
      @pushWrapper.receive_midi message

    @midiInput.openPort 0
    @midiOutput.openPort 0
    @_setupButtons()

  _setupButtons: =>
    for x in [1...9]
      for y in [1...9]
        @_setupButton({x,y})

  _setupButton: ({x,y}) =>
    @pushWrapper.grid.x[x].y[y].led_rgb(255,0,0)
    @pushWrapper.grid.x[x].y[y].on 'pressed', (velocity) =>
      @emit 'message', {x,y, velocity}

module.exports = Ableton
