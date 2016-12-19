Ableton = require '..'

config =
  buttons: [
    {
      x:1
      y:1
      color:
        r: 255
        g: 0
        b: 0
      }
  ]

console.log config
ableton = new Ableton config

green = {r: 0, g: 255, b: 0}

ableton.on 'button', ({x,y,velocity,color}) =>
  console.log({x,y,velocity,color})
  ableton.setButtonColor {x,y, color: {r: 0, g: velocity*2, b: 0}}

ableton.connect()
