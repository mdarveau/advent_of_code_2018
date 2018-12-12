fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

createGrid = (serialNumber) ->
  grid = []
  for y in [1..300]
    row = []
    for x in [1..300]
      power = x + 10
      power *= y
      power += serialNumber
      power *= x + 10
      power = Math.floor((power / 100) % 10)
      power -= 5
      row.push power
    grid.push row
  return grid

findMax = (grid, squareSize, cache) ->
  max = Number.MIN_SAFE_INTEGER
  point = null
  for y in [0...(300 - (squareSize-1))]
    for x in [0...(300 - (squareSize-1))]
      value = 0
      if cache?
        value = cache[y][x]
        for dx in [0...squareSize]
          value += grid[y + squareSize - 1][x + dx]
        for dy in [0...squareSize]
          value += grid[y + dy][x + squareSize - 1]
      else
        for dx in [0...squareSize]
          for dy in [0...squareSize]
            value += grid[y + dy][x + dx]
      cache?[y][x] = value
      if value > max
        max = value
        point = [x + 1, y + 1, value]
  point

findMaxAnySize = (grid) ->
  cache = _.cloneDeep grid
  max = 0
  result = null
  for squareSize in [2..300]
    console.log "Processing squareSize: #{squareSize}"
    [x, y, value] = findMax(grid, squareSize, cache)
    if value > max
      max = value
      result = [x, y, squareSize]
  return result

grid = createGrid(1133)

console.log "A: " + findMax(grid, 3)
console.log "B: " + findMaxAnySize(grid)
