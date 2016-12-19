_              = require 'lodash'
PushWrapper    = require 'push-wrapper'
midi           = require 'midi'
{EventEmitter} = require 'events'

class Ableton extends EventEmitter
  constructor: ({@buttons=[]}={}) ->
  connect: =>
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


    console.log @buttons
    @_setButtonColors()


  setButtonColor:({x,y,color}) =>
    @buttons = _.reject @buttons, {x,y,color}
    @buttons.push {x,y,color}
    @_setButtonColors()

  _setButtonColors: =>
    _.each @buttons, @_setButtonColor

  _setButtonColor:({x,y,color}) =>
    {r,g,b} = color || {}
    @pushWrapper.grid.x[x].y[y].led_rgb(r,g,b)

  _setupButton: ({x,y}) =>
    @pushWrapper.grid.x[x].y[y].led_rgb(0,0,0)
    @pushWrapper.grid.x[x].y[y].on 'pressed', (velocity) =>
      message = {x,y, velocity}
      buttonConfig = _.find @buttons, {x,y}
      message.color = buttonConfig.color if buttonConfig?
      @emit 'button', message

module.exports = Ableton
