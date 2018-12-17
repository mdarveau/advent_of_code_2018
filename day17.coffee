fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

printMap = (map)->
  console.log ""
  for r in map
    console.log r.slice(box.x.min - 1, box.x.max + 2).join('')

#x=495, y=2..7
regex = "(.)=(\\d*), (.)=(\\d*)\\.\\.(\\d*)"

scans = aoc.parseArray(fs.readFileSync('./data/day17.txt'), '\n').map (d)->
  matches = d.match(regex)
  {
    coord1Direction: matches[1]
    coord1Value: parseInt matches[2]
    coord2Direction: matches[3]
    coord2ValueFrom: parseInt matches[4]
    coord2ValueTo: parseInt matches[5]
  }

box =
  x:
    min: Number.MAX_VALUE
    max: Number.MIN_SAFE_INTEGER
  y:
    min: Number.MAX_VALUE
    max: Number.MIN_SAFE_INTEGER

for scan in scans
  box[scan.coord1Direction].min = Math.min(box[scan.coord1Direction].min, scan.coord1Value)
  box[scan.coord2Direction].min = Math.min(box[scan.coord2Direction].min, scan.coord2ValueFrom)
  box[scan.coord1Direction].max = Math.max(box[scan.coord1Direction].max, scan.coord1Value)
  box[scan.coord2Direction].max = Math.max(box[scan.coord2Direction].max, scan.coord2ValueTo)

map = []
for y in [0..box.y.max]
  row = []
  for x in [0..box.x.max]
    row.push '.'
  map.push row

for scan in scans
  if scan.coord1Direction == 'x'
    for y in [scan.coord2ValueFrom..scan.coord2ValueTo]
      map[y][scan.coord1Value] = '#'
  else
    for x in [scan.coord2ValueFrom..scan.coord2ValueTo]
      map[scan.coord1Value][x] = '#'

isHardSurface = (cell) ->
  cell == '#' or cell == '~'

flood = (map, x, y, direction) ->
  return true if map[y][x] == '#'

  map[y][x] = '|'

  # Drip water down
  dripWater(map, x, y + 1)

  if isHardSurface(map[y + 1]?[x])
    # Continue flood
    return flood(map, x + direction, y, direction)
  else
    return false

setHardWater = (map, x, y, direction) ->
  return if map[y][x] == '#'
  map[y][x] = '~'
  setHardWater(map, x + direction, y, direction)

# Return true if drip worked
dripWater = (map, x, y) ->
  return false if y > box.y.max
  return false if isHardSurface(map[y][x]) if map[y]?

  map[y][x] = '|'

  # Drip water down
  dripWater(map, x, y + 1)

  # Are we on "hard" surface?
  if isHardSurface(map[y + 1]?[x])
    hitSurfaceLeft = flood(map, x - 1, y, -1)
    hitSurfaceRight = flood(map, x + 1, y, 1)
    if hitSurfaceLeft and hitSurfaceRight
      setHardWater(map, x, y, -1)
      setHardWater(map, x + 1, y, 1)

  return true

map[0][500] = "+"
dripWater(map, 500, 1)
printMap(map)

countTouched = 0
countWater = 0
for y in [1..box.y.max]
  for x in [0..box.x.max]
    countTouched++ if map[y][x] == '|' or map[y][x] == '~'
    countWater++ if map[y][x] == '~'

console.log "A: #{countTouched - box.y.min + 1}"
console.log "B: #{countWater}"
