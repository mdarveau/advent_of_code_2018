fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

regex = "Step (.) must be finished before step (.) can begin."

instructions = aoc.parseArray(fs.readFileSync('./data/day7.txt'), '\n').map (d)->
  matches = d.match(regex)
  {
    before: matches[1]
    after: matches[2]
  }

stepsForward = {}
stepsBackwards = {}
allKnownSteps = []
for instruction in instructions
  (stepsForward[instruction.before] ?= []).push instruction.after
  (stepsBackwards[instruction.after] ?= []).push instruction.before
  allKnownSteps.push instruction.before
  allKnownSteps.push instruction.after

allKnownSteps = _.uniq allKnownSteps

#console.log allKnownSteps
console.log stepsForward
console.log stepsBackwards

# Find all roots
stepQueue = []
for step in allKnownSteps
  stepQueue.push step unless stepsBackwards[step]?
stepQueue = _.sortBy stepQueue

completedSteps = []

while(stepQueue.length != 0)
  step = (stepQueue.filter ( step )->
    _.difference(stepsBackwards[step], completedSteps).length == 0
  ).shift()
  _.pull( stepQueue, step )
  console.log "Processing step " + step
  completedSteps.push(step)
  stepQueue = _.sortBy(_.difference(stepQueue.concat(stepsForward[step]), completedSteps))

console.log "A: " + completedSteps.join('')
