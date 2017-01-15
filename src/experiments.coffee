Ableton = require '..'
_       = require 'lodash'

config =
  buttons: [
    {
      x:1
      y:1
      color: 'red'
    }
    {
      x:2
      y:2
      color: 'purple'
    }
    {
      x:3
      y:2
      color: 'yellow'
    }
    {
        x:3
        y:4
        color: 'green'
    }
  ]

console.log config
ableton = new Ableton config

ableton.on 'button', ({x,y,velocity,color}) =>
  console.log({x,y,velocity,color})
  ableton.setButtonColor {x,y, color: {r: 0, g: velocity*2, b: 0}}

ableton.connect()
