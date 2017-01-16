_              = require 'lodash'
PushWrapper    = require 'push-wrapper'
midi           = require 'midi'
{EventEmitter} = require 'events'
tinycolor      = require 'tinycolor2'

class Ableton extends EventEmitter
  constructor: ({@buttons=[]}={}) ->

  connect: =>
    @midiInput = new midi.input()
    @midiOutput = new midi.output()

    @pushWrapper = new PushWrapper send: (bytes) => @midiOutput.sendMessage(bytes)

    @midiInput.on 'message', (deltaTime, message) =>
      firstByte = _.first message
      if firstByte != 208
        @lastMessage = message
      else
        message = [@lastMessage[0], @lastMessage[1], _.last message]

      @pushWrapper.receive_midi message

    @midiInput.openPort 0
    @midiOutput.openPort 0
    @_setupButtons()

  _setupButtons: =>
    for x in [1...9]
      for y in [1...9]
        @_setupButton({x,y})

    @_setButtonColors()


  setButtonColors: (@buttons=[]) => @_setButtonColors()

  setButtonColor: ({x,y,color}={}) =>
    console.log {x,y,color}
    @buttons = _.reject @buttons, {x,y}
    @buttons.push {x,y,color}
    @_setButtonColors()

  _setButtonColors: =>
    console.log 'hi', @buttons
    _.each @buttons, @_setButtonColor

  _setButtonColor:({x,y,color}={}) =>
    {r,g,b} = tinycolor(color).toRgb()
    @pushWrapper.grid.x[x].y[y].led_rgb(r,g,b)

  _setupButton: ({x,y}) =>
    @pushWrapper.grid.x[x].y[y].led_rgb(0,0,0)
    @pushWrapper.grid.x[x].y[y].on 'pressed', (velocity) => @_onPressed {x,y,velocity}
    @pushWrapper.grid.x[x].y[y].on 'released', (velocity) => @_onPressed {x,y,velocity}
    @pushWrapper.grid.x[x].y[y].on 'aftertouch', (velocity) => @_onPressed {x,y,velocity}

  _onPressed: ({x,y,velocity}) =>
    message = {x,y, velocity}
    buttonConfig = _.find @buttons, {x,y}
    message.color = buttonConfig.color if buttonConfig?
    @emit 'button', message


module.exports = Ableton
