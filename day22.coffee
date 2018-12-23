fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

#depth = 510
#width = 200
#target = {x: 10, y: 10}

depth = 5616
width = 200
target = {x: 10, y: 785}

map = []
for y in [0...depth]
  row = []
  for x in [0...width]
    row.push {gi: null, el: null}
  map.push row

for y in [0...map.length]
  for x in [0...map[y].length]
    if (x == 0 and y == 0) or (x == target.x and y == target.y)
      map[y][x].gi = 0
    else if y == 0
      map[y][x].gi = x * 16807
    else if x == 0
      map[y][x].gi = y * 48271
    else
      map[y][x].gi = map[y][x - 1].el * map[y - 1][x].el

    map[y][x].el = (map[y][x].gi + depth) % 20183
    map[y][x].type = switch map[y][x].el % 3
      when 0 then '.'
      when 1 then '='
      when 2 then '|'

    if x == 0 and y == 0
      map[y][x].type = 'M'
    else if x == target.x and y == target.y
      map[y][x].type = 'T'

printMap = (map, depth = map.length)->
  for y in [0...depth]
    console.log _.map(map[y], 'type').join('')


#printMap(map)

computeRisk = (map, target)->
  risk = 0
  for y in [0..target.y]
    for x in [0..target.x]
      risk += (switch map[y][x].type
        when '.' then 0
        when '=' then 1
        when '|' then 2
        else 0
      )
  return risk

console.log "A: " + computeRisk(map, target)

tools = ['T', 'C', '-']
terrainTools = {
  '.': ['T', 'C']
  '=': ['C', '-']
  '|': ['T', '-']
  'M': ['T']
  'T': ['T', 'C'] # Target is rocky (.)
}
offsetVectors = [{x: 0, y: -1}, {x: 1, y: 0}, {x: 0, y: 1}, {x: -1, y: 0}]

findTarget = (map)->
  queue = []
  maxX = 0
  maxY = 0

  queue.push {
      x: 0
      y: 0
      tool: 'T'
      time: 0
  }

  count = 0
  sortCount = 0

  while queue.length != 0
    queue = _.sortBy queue, 'time' if ++sortCount % 1000 == 0
    current = queue.shift()
    map[current.y][current.x].time ?= {}
    continue if map[current.y][current.x].time[current.tool] <= current.time

#    console.log "At #{current.x}, #{current.y} @ #{current.time}. Queue size #{queue.length}" if ++count % 1000 == 0
#    if current.x > maxX
#      maxX = current.x
#      console.log "At #{current.x}, #{current.y}"
#
#    if current.y > maxY
#      maxY = current.y
#      console.log "At #{current.x}, #{current.y}"

    map[current.y][current.x].time[current.tool] = current.time

    if current.x == target.x and current.y == target.y
#      return current.time + (if current.tool == 'T' then 0 else 7)
      console.log "At target in #{current.time + (if current.tool == 'T' then 0 else 7)}"

    for offsetVector in offsetVectors
      newX = current.x + offsetVector.x
      newY = current.y + offsetVector.y
      continue if newX < 0 or newY < 0 or newX >= width or newY >= depth

      # Confirm valid equipment
      if not _.includes terrainTools[map[newY][newX].type], current.tool
        # Switch tool
        for newTool in terrainTools[map[newY][newX].type]
          queue.push {
            x: newX
            y: newY
            tool: newTool
            time: current.time + 8 # 7 min to switch tool + 1 min to move
          }
      else
        queue.push {
          x: newX
          y: newY
          tool: current.tool
          time: current.time + 1
        }
  return "min ^"

console.log "B: " + findTarget(map)
