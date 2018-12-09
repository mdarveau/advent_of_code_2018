fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

moveCurrent = (current, step) ->
  direction = if step < 0 then 'previous' else 'next'
  current = current[direction] for x in [1..Math.abs(step)]
  return current

insertMarble = (current, marbleNo) ->
  newCurrent = {
    marbleNo: marbleNo
    previous: current
    next: current.next
  }
  current.next.previous = newCurrent
  current.next = newCurrent
  current = newCurrent
  return current

removeCurrentMarble = (current) ->
  current.previous.next = current.next
  current.next.previous = current.previous
  current = current.next
  return current

play = (nbPlayers, lastMarble)->
  currentPlayer = 1
  playerScores = []
  playerScores[playerNo] = 0 for playerNo in [1...nbPlayers]

  current = {
    marbleNo: 0
  }
  current.next = current
  current.previous = current

  for marbleNo in [1..lastMarble]
    currentPlayer = marbleNo % nbPlayers
    if marbleNo % 23 == 0
      playerScores[currentPlayer] += marbleNo
      current = moveCurrent(current, -7)
      playerScores[currentPlayer] += current.marbleNo
      current = removeCurrentMarble(current)
    else
      current = moveCurrent(current, 1)
      current = insertMarble(current, marbleNo)

  _.max playerScores

console.log "A: #{play(459, 71790)}"
console.log "B: #{play(459, 7179000)}"
