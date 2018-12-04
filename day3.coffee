fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

regex = "#(\\d*) @ (\\d*),(\\d*): (\\d*)x(\\d*)"

patches = aoc.parseArray(fs.readFileSync('./data/day3.txt'), '\n').map (d)->
  matches = d.match(regex)
  {
    number: matches[1]
    x: parseInt matches[2]
    y: parseInt matches[3]
    w: parseInt matches[4]
    h: parseInt matches[5]
  }

grid = []
grid.push [] for x in [0...1000]

for patch in patches
  for i in [patch.x...patch.x + patch.w]
    for j in [patch.y...patch.y + patch.h]
      grid[i][j] ?= 0
      grid[i][j]++

count = 0
for x in [0...1000]
  for y in [0...1000]
    count++ if grid[x][y] >= 2

console.log "A: " + count

for patch in patches
  overlap = false
  for i in [patch.x...patch.x + patch.w]
    for j in [patch.y...patch.y + patch.h]
      overlap = true if grid[i][j] > 1
  console.log "B: " + patch.number unless overlap
