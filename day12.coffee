fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

inputStringToBigInt = (stateString) ->
  value = BigInt(0)
  for x in [0...stateString.length]
    value <<= BigInt(1)
    value += BigInt(1) if stateString.charAt(x) == '#'
  value

bigIntToInputString = (value) ->
  output = ""
  while value != BigInt(0)
    output = (if value & BigInt(1) then '#' else '.') + output
    value >>= BigInt(1)
  output

rawRules = aoc.parseArray(fs.readFileSync('./data/day12.txt'), '\n').map (d)->
  matches = d.match("(.....) => (.)")
  {
    pattern: inputStringToBigInt(matches[1])
    result: matches[2] == "#"
  }

rules = []
for rule in rawRules
  rules[rule.pattern] = rule.result

computeNextGeneration = (state, offset) ->
  newState = BigInt(0)
  newOffset = offset

  # Add bits to the right, but track of of many we add so we can recompute the right pot number at the end
  rightPad = ->
    state <<= BigInt(1)
    newOffset++

  rightPad() if state & BigInt(1)
  rightPad() if state & BigInt(2)
  rightPad() if state & BigInt(4)

  bit = BigInt(2)
  while state != BigInt(0)
    rule = state & BigInt(0b11111)
    newState += BigInt(1) << bit if rules[rule]
    bit++
    state >>= BigInt(1)

  return [newState, newOffset]

computeValue = ( initialStateStringLength, state, offset)->
  lsbPotValue = initialStateStringLength + offset - 1
  sum = 0
  while state != BigInt(0)
    sum += lsbPotValue if state & BigInt(1)
    state >>= BigInt(1)
    lsbPotValue--
  return sum

run = (initialStateString, nbGenerations)->
  initialStateStringLength = initialStateString.length
  initialState = inputStringToBigInt(initialStateString)
  offset = 0

  state = initialState
  lastHundreedStates = []
  for generation in [1..nbGenerations]
    console.log "Generation #{(generation/50000000000.0)*100}" if generation % 100000 == 0
    [state, offset] = computeNextGeneration(state, offset)
    lastHundreedStates.push state
    lastHundreedStates.shift() if lastHundreedStates.length > 100
    console.log "Generation #{generation}: #{bigIntToInputString(state)} (#{state}) (offset: #{offset}), value #{computeValue(initialStateStringLength, state, offset)}"
    if lastHundreedStates.length == 100 and _.sum(lastHundreedStates)/BigInt(lastHundreedStates.length) == state
      # Looking at the result, the offset happens to be the generation number
      return computeValue(initialStateStringLength, state, nbGenerations)

  return computeValue(initialStateStringLength, state, offset)

initialState = ".#..##..#.....######.....#....####.##.#.#...#...##.#...###..####.##.##.####..######......#..##.##.##"
console.log "A: #{run(initialState, 20)}"
console.log "B: #{run(initialState, 50000000000)}"
