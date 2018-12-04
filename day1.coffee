fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

data = aoc.parseIntArray(fs.readFileSync('./data/day1.txt'), '\n')

console.log "Part A: " + _.sum data

freq = 0
freqHistory = {}
while true
  for newFreq in data
    freq += newFreq
    freqHistory[freq] = (freqHistory[freq] ? 0) + 1
    if freqHistory[freq] == 2
      console.log "Part B: " + freq
      process.exit( 0 )
