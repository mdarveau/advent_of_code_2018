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

nbWorkers = 5
workersAssignation = []
workersRemainingTime = []

fetchAssignation = ->
  step = (stepQueue.filter ( step )->
    _.difference(stepsBackwards[step], completedSteps).length == 0
  ).shift()
  _.pull( stepQueue, step )
  return step

second = 0
while true
  for workerNo in [1..nbWorkers]
    step = workersAssignation[workerNo]
    if step?
      workersRemainingTime[workerNo]--
      if workersRemainingTime[workerNo] == 0
        console.log "Worker #{workerNo} finished processing step #{step} at #{second} second"
        workersAssignation[workerNo] = null
        completedSteps.push(step)
        stepQueue = _.sortBy(_.difference(stepQueue.concat(stepsForward[step]), completedSteps))

  for workerNo in [1..nbWorkers]
    unless workersAssignation[workerNo]?
      step = fetchAssignation()
      if step?
        workersAssignation[workerNo] = step
        workersRemainingTime[workerNo] = step.charCodeAt(0) - 4
        console.log "Worker #{workerNo} start processing step #{step} for #{workersRemainingTime[workerNo]} seconds"

  if stepQueue.length == 0 and workersAssignation.join('') == ""
    console.log "B: " + second
    process.exit( 0 )

  second++


