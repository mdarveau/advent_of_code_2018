fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

threshold = 10000
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
    grid[y][x] = 0

# Compute distance of every coordinate for every points
for y in [0..maxY]
  for x in [0..maxX]
    for point in data
#      console.log "y: #{y}, x:#{x}: #{grid[y][x]}"
      grid[y][x] += Math.abs(point.y - y) + Math.abs(point.x - x)

# Keep closest point
areaSize = 0
for y in [0..maxY]
  for x in [0..maxX]
    if grid[y][x] < threshold
      grid[y][x] = '#'
      areaSize++
    else
    grid[y][x] = '.'

aoc.print2DArray(grid, ' ')

console.log "B: #{areaSize}"

