fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

rules = aoc.parseArray(fs.readFileSync('./data/day12.txt'), '\n').map (d)->
  matches = d.match("(.....) => (.)")
  {
    pattern: matches[1].split('').map (chr) -> chr == "#"
    result: matches[2] == "#"
  }

computeNextGeneration = (state) ->
  unshiftState = ->
    state.unshift(false)
    state.zeroOffset++

  # Make sure there is enough place on the left
  unshiftState() if state[0]
  unshiftState() if state[1]
  unshiftState() if state[2]
  state.push(false) if state[state.length - 1]
  state.push(false) if state[state.length - 2]
  state.push(false) if state[state.length - 3]

  newState = _.cloneDeep(state)
  for x in [2...state.length - 2]
    hasPlant = false
    for rule in rules
      pattern = rule.pattern
      #      console.log "Checking rule #{stateToString(rule.pattern)}"
      if state[x - 2] == pattern[0] and state[x - 1] == pattern[1] and state[x] == pattern[2] and state[x + 1] == pattern[3] and state[x + 2] == pattern[4]
#        console.log "Match: has plant = #{rule.result}"
        hasPlant = rule.result
        break
    #    console.log "#{x} has plant #{hasPlant}"
    throw Error("No result for #{x}") unless hasPlant?
    newState[x] = hasPlant
  newState.zeroOffset = state.zeroOffset
  return newState

stateToString = (state)-> state.map((val) -> if val then '#' else '.').join('')

run = (initialState, nbGenerations)->
  initialState = initialState.split('').map (chr) -> chr == "#"
  initialState.zeroOffset = 0

  state = initialState
  for generation in [1..nbGenerations]
    console.log "Generation #{generation}" if generation % 1000 == 0
    state = computeNextGeneration(state)

  sum = 0
  for x in [0...state.length]
    sum += x - state.zeroOffset if state[x]
  return sum

initialState = ".#..##..#.....######.....#....####.##.#.#...#...##.#...###..####.##.##.####..######......#..##.##.##"
console.log "A: #{run(initialState, 20)}"
console.log "A: #{run(initialState, 50000000000)}"
