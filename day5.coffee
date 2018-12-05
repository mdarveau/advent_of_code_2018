fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

data = "" + fs.readFileSync('./data/day5.txt')

reduce = ( data ) ->
  reduceIteration = () ->
    modified = false
    x = 0
    while x < data.length-1
      if Math.abs(data.charCodeAt(x) - data.charCodeAt(x+1)) == 32
        data = data.substring(0, x) + data.substring(x+2)
        modified = true
      else
        x++
    return modified

  while reduceIteration()
    true

  return data.length - 1

a = reduce(data)

min = 9999999
for chr in [65..90]
  len = reduce(data.replace(new RegExp(String.fromCharCode(chr), 'g'), '').replace(new RegExp(String.fromCharCode(chr+32), 'g'), ''))
  min = len if len < min
b = min

console.log "A: #{a}"
console.log "B: #{b}"
