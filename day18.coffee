fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

map = aoc.parse2DArray(fs.readFileSync('./data/day18.txt'), '')

aoc.print2DArray(map, '')

getNodesAround = (map, x, y) ->
  nodes = []
  for dx in [-1, 0, 1]
    for dy in [-1, 0, 1]
      continue if dx == 0 and dy == 0
      nodes.push map[y + dy][x + dx] if map[y + dy]?[x + dx]?
  return nodes

step = (map) ->
  nextMap = aoc.makeNew2DArray(map, '.')
  for y in [0...map.length]
    for x in [0...map[y].length]
      current = map[y][x]
      nodes = getNodesAround(map, x, y)
      nodeCounts = _.countBy nodes
      if current == '.'
        nextMap[y][x] = '|' if nodeCounts['|'] >= 3
      else if current == '|'
        nextMap[y][x] = if nodeCounts['#'] >= 3 then '#' else '|'
      else if current == '#'
        nextMap[y][x] = if nodeCounts['#'] >= 1 and nodeCounts['|'] >= 1 then '#' else '.'
      else
        nextMap[y][x] = current
  return nextMap

for minute in [1..10]
  map = step(map)
#  console.log "After #{minute} minute:"
#  aoc.print2DArray(map, '')

nbWoods = aoc.countIn2DArray( map, '|')
nbLumberyards = aoc.countIn2DArray( map, '#')
#console.log "nbWoods #{nbWoods}"
#console.log "nbLumberyards #{nbLumberyards}"
console.log "A: #{nbWoods * nbLumberyards}"
