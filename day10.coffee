fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

regex = "position=<(.*), (.*)> velocity=<(.*), (.*)>"

points = aoc.parseArray(fs.readFileSync('./data/day10.txt'), '\n').map (d)->
  matches = d.match(regex)
  {
    x: parseInt(matches[1])
    y: parseInt(matches[2])
    vX: parseInt(matches[3])
    vY: parseInt(matches[4])
  }


stepCount = 0
step = ->
  stepCount++
  for point in points
    point.x += point.vX
    point.y += point.vY

paint = ->
#  console.log points

  bX = _.minBy(points, 'x').x
  bY = _.minBy(points, 'y').y

  width = _.maxBy(points, 'x').x - bX
  height= _.maxBy(points, 'y').y - bY

#  console.log "#{bX}, #{bY} - #{width}x#{height}"
  return if height > 10

  board = []
  for y in [0..height]
    line = []
    for x in [0..width]
      line.push '.'
    board.push line

  for point in points
#    console.log "Painting #{point.y - bY}x#{point.x - bX} (#{point.x}x#{point.y} - #{bX} #{bY})"
    board[point.y - bY][point.x - bX] = '#'
  console.log "At #{stepCount}sec"

  aoc.print2DArray(board, '')

#setInterval(->
#  paint()
#  step()
#, 10)

while true
  paint()
  step()

#console.log points
