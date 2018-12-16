fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

data = aoc.parse2DArray(fs.readFileSync('./data/day15_test.txt'), '')

offsetVectors = [{x: 0, y: -1}, {x: 1, y: 0}, {x: 0, y: 1}, {x: -1, y: 0}]

makeEmptyMap = (data, initValue = null) ->
  emptyMap = []
  for y in [0...data.length]
    row = []
    for x in [0...data[y].length]
      row.push initValue
    emptyMap.push row
  return emptyMap

putPointsInMap = (data, points, chr)->
  map = makeEmptyMap(data, '.')
  map[point.y][point.x] = chr for point in points
  return map

getPointsInMap = (data, chr)->
  points = []
  for y in [0...data.length]
    for x in [0...data[y].length]
      if data[y][x] == chr
        points.push {
          x
          y
        }
  return points

extractUnits = (data) ->
  units = []
  units = units.concat getPointsInMap(data, 'E').map (point) -> point.type = 'E'; point.enemyType = 'G'; point.hitPoints = 200; return point;
  units = units.concat getPointsInMap(data, 'G').map (point) -> point.type = 'G'; point.enemyType = 'E'; point.hitPoints = 200; return point;
  return units

getEnnemiesInRangePoints = (data, currentUnit, units) ->
  points = []
  for unit in units
    continue unless unit.type != currentUnit.type
    for offsetVector in offsetVectors
      if data[unit.y + offsetVector.y][unit.x + offsetVector.x] == '.'
        points.push {
          x: unit.x + offsetVector.x
          y: unit.y + offsetVector.y
        }
  return points

computeReachableMap = (data, fromX, fromY) ->
  reachableMap = makeEmptyMap(data, '.')
  scout = (x, y) ->
    return unless reachableMap[y][x] == '.'
    return unless data[y][x] == '.'
    reachableMap[y][x] = '@'
    for offsetVector in offsetVectors
      scout(x + offsetVector.x, y + offsetVector.y)

  for offsetVector in offsetVectors
    scout(fromX + offsetVector.x, fromY + offsetVector.y)
  return reachableMap

getDistanceMap = (data, fromX, fromY, toX, toY) ->
  distanceMap = makeEmptyMap(data, null)
  distanceMap[fromY][fromX] = 0
  move = (x, y, distance) ->
    return unless data[y][x] == '.'
    return if x == toX and y == toY
    return if distanceMap[y][x]? and distanceMap[y][x] <= distance
    distanceMap[y][x] = distance
    for offsetVector in offsetVectors
      move(x + offsetVector.x, y + offsetVector.y, distance + 1)

  for offsetVector in offsetVectors
    move(fromX + offsetVector.x, fromY + offsetVector.y, 1)

  return distanceMap

getPointsAround = (map, x, y) ->
  points = []
  for offsetVector in offsetVectors
    dx = x + offsetVector.x
    dy = y + offsetVector.y
    points.push {x: dx, y: dy, value: map[dy][dx]} if map[dy][dx]?
  return points

getMinPointsAround = (distanceMap, x, y) ->
  pointsAround = getPointsAround(distanceMap, x, y)
  minAround = _.minBy(pointsAround, 'value').value
  return _.filter pointsAround, {value: minAround}

getMinAround = (distanceMap, x, y) ->
  return _.minBy(getPointsAround(distanceMap, x, y), 'value').value

units = extractUnits(data)


completedRounds = 0

# Rounds loop
while true
  units = _.sortBy units, ['y', 'x']
  for unit, x in units
    enemyRangePoints = getEnnemiesInRangePoints(data, unit, units)
    if enemyRangePoints.length == 0
      console.log "Combat end after #{completedRounds} completed rounds. Unit #{JSON.stringify(unit)} has no enemy"
      process.exit(0)

    # Check for combat
    inRangeOfCombat = _.some getPointsAround( data, unit.x, unit.y ), {value: unit.enemyType}

    if inRangeOfCombat

    else
      reachableMap = computeReachableMap(data, unit.x, unit.y)
      # Get points that are reachable
      enemyRangePoints = _.filter enemyRangePoints, (point) -> reachableMap[point.y][point.x] == '@'
      continue if enemyRangePoints.length == 0

      # Compute distance to all target range points
      for enemyRangePoint in enemyRangePoints
        distanceMap = getDistanceMap(data, unit.x, unit.y, enemyRangePoint.x, enemyRangePoint.y)
  #      aoc.print2DArray( distanceMap, '', '.')
  #      console.log getMinAround(distanceMap, enemyRangePoint.x, enemyRangePoint.y)
        enemyRangePoint.distanceFromUnit = getMinAround(distanceMap, enemyRangePoint.x, enemyRangePoint.y)

  #    console.log "enemyRangePoints: #{JSON.stringify(enemyRangePoints, null, '  ')}"

      # Select nearest point
      minDistance = _.minBy(enemyRangePoints, 'distanceFromUnit').distanceFromUnit
  #    console.log "Min distance: #{minDistance}"
      enemyRangePoints = _.filter enemyRangePoints, {distanceFromUnit: minDistance}
      enemyRangePoints = _.sortBy enemyRangePoints, ['y', 'x']

  #    console.log "Selected enemyRangePoints: #{JSON.stringify(enemyRangePoints)}"

      chosenTargetRangePoint = enemyRangePoints[0]
  #    console.log chosenTargetRangePoint

      # Get distances back to the unit (to get the direction of the shortest path)
      distanceMap = getDistanceMap(data, chosenTargetRangePoint.x, chosenTargetRangePoint.y, unit.x, unit.y)
  #    aoc.print2DArray( distanceMap, '', '.')
      newPosition = _.sortBy(getMinPointsAround(distanceMap, unit.x, unit.y), ['y', 'x'])[0]
      console.log "Unit #{unit.type} at #{unit.x}, #{unit.y} will move to #{newPosition.x}, #{newPosition.y}"
      data[unit.y][unit.x] = '.'
      unit.x = newPosition.x
      unit.y = newPosition.y
      data[unit.y][unit.x] = unit.type

      #    aoc.print2DArray(putPointsInMap(data, enemyRangePoints, '?'), '')

#  process.exit(0)

  completedRounds++
  console.log "After #{completedRounds} completed rounds:"
  aoc.print2DArray(data, '')
  if completedRounds == 3
    process.exit(0)
