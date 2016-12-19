Ableton = require './Ableton'

ableton = new Ableton()

ableton.on 'message', console.log
ableton.connect()
