fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

data = aoc.parseArray(fs.readFileSync('./data/day2.txt'), '\n')

doubles = 0
triples = 0

for box in data
  counts = _.countBy(box)
  doubles++ if _.includes(_.values(counts), 2)
  triples++ if _.includes(_.values(counts), 3)

console.log "A: " + (doubles * triples)

for x in [0...data.length]
  for y in [x...data.length]
    diffs = null
    diffPosition = null;
    for z in [0...data[x].length]
      if data[x][z] != data[y][z]
        diffs++
        diffPosition = z
    if diffs == 1
      console.log "B: " + data[x].substring(0, diffPosition) + data[x].substring(diffPosition + 1)
