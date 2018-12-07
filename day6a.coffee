fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

data = aoc.parseArray(fs.readFileSync('./data/day6.txt'), '\n').map (d, index) ->
  d = d.split(', ')
  d.x = parseInt(d[0])
  d.y = parseInt(d[1])
  d.no = index
  d

# Find grid size
maxX = _.maxBy(data, 'x').x + 1
maxY = _.maxBy(data, 'y').y + 1

console.log "Grid size is #{maxX}x#{maxY}"

grid = [maxY]
for y in [0..maxY]
  grid[y] = [maxX]
  for x in [0..maxX]
    grid[y][x] = {}

for point in data
  grid[point.y][point.x] = point.no

# Compute distance of every coordinate for every points
for y in [0..maxY]
  for x in [0..maxX]
    for point in data
#      console.log "y: #{y}, x:#{x}: #{grid[y][x]}"
      grid[y][x][point.no] = Math.abs(point.y - y) + Math.abs(point.x - x) unless Number.isInteger(grid[y][x])

# Keep closest point
for y in [0..maxY]
  for x in [0..maxX]
    continue if Number.isInteger(grid[y][x])
    distances = _.invertBy(grid[y][x])
    minDistance = "#{_.minBy(_.keys(distances), parseInt)}"
#    console.log "Point #{x}x#{y}, minDistance: #{minDistance}, distances: #{JSON.stringify(distances)}, distances[minDistance]: #{JSON.stringify(distances[minDistance])}"
    if distances[minDistance].length == 1
      grid[y][x] = parseInt(distances[minDistance][0])
    else
      grid[y][x] = '.'

aoc.print2DArray(grid, ' ')

infinitePoints = []
for y in [0..maxY]
  if y == 0 or y == maxY
    infinitePoints = infinitePoints.concat(grid[y])
  else
    infinitePoints.push(grid[y][0])
    infinitePoints.push(grid[y][maxX])
infinitePoints = _.uniq(infinitePoints)

console.log "Infinite points: #{infinitePoints}"

areaSize = {}
for y in [0..maxY]
  for x in [0..maxX]
    areaSize[grid[y][x]] ?= 0
    areaSize[grid[y][x]]++

for infinitePoint in infinitePoints
  delete areaSize[infinitePoint]

console.log areaSize

console.log "A: " + _.max(_.values(areaSize))
