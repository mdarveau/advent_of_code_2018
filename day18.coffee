fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

countNodesAround = (map, x, y) ->
  nodes = {'|': 0, '#': 0, '.': 0}
  for dx in [-1, 0, 1]
    for dy in [-1, 0, 1]
      continue if dx == 0 and dy == 0
      nodes[map[y + dy][x + dx]]++ if map[y + dy]?[x + dx]?
  return nodes

step = (sourceMap, targetMap) ->
  for y in [0...sourceMap.length]
    for x in [0...sourceMap[y].length]
      current = sourceMap[y][x]
      nodeCounts = countNodesAround(sourceMap, x, y)
      if current == '.'
        targetMap[y][x] = if nodeCounts['|'] >= 3 then '|' else '.'
      else if current == '|'
        targetMap[y][x] = if nodeCounts['#'] >= 3 then '#' else '|'
      else if current == '#'
        targetMap[y][x] = if nodeCounts['#'] >= 1 and nodeCounts['|'] >= 1 then '#' else '.'

run = (nbMinutes) ->
  history = {}
  counts = {}
  loopStart = null
  loopEnd = null
  targetMinute = null
  map = aoc.parse2DArray(fs.readFileSync('./data/day18.txt'), '')
  nextMap = aoc.makeNew2DArray(map, '.')
  for minute in [1..nbMinutes]
    console.log "Processing #{minute / nbMinutes}" if minute % 10000 == 0
    step(map, nextMap)
    swap = nextMap
    nextMap = map
    map = swap

    break if minute == targetMinute

    continue if targetMinute?

    hash = aoc.hash2DArray(map)
    if history[hash]?
      counts[hash] = (counts[hash] ? 0) + 1
      if counts[hash] == 3
        loopLength = (loopEnd - loopStart) + 1
        targetMinute = minute + (nbMinutes - minute) % loopLength
      loopStart = history[hash] if not loopStart? and counts[hash] == 2
      loopEnd = history[hash] if counts[hash] == 2
    else
      history[hash] = minute

  nbWoods = aoc.countIn2DArray(map, '|')
  nbLumberyards = aoc.countIn2DArray(map, '#')
  nbWoods * nbLumberyards

console.log "A: #{run(10)}"
console.log "B: #{run(1000000000)}"
