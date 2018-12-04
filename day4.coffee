fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

regex = "\\[(.*)\\] (.*)"

logs = aoc.parseArray(fs.readFileSync('./data/day4.txt'), '\n').map (d)->
  matches = d.match(regex)
  {
    time: matches[1]
    minute: parseInt(matches[1].match("\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:(\\d\\d)")?[1])
    newGuard: matches[2].indexOf('begins shift') != -1
    guardNo: matches[2].match('Guard #(\\d*) begins shift')?[1]
    fallsAsleep: matches[2].indexOf('falls asleep') != -1
    wakesUp: matches[2].indexOf('wakes up') != -1
    log: d
  }

logs = _.sortBy(logs, 'time')

sleepPeriods = []
sleepPeriod = {}
for log in logs
  if log.newGuard
    sleepPeriod = {
      guardNo: log.guardNo
    }
  else if log.fallsAsleep
    sleepPeriod.start = log.minute
  else if log.wakesUp
    sleepPeriod.end = log.minute
    sleepPeriods.push sleepPeriod
    sleepPeriod = {
      guardNo: sleepPeriod.guardNo
    }

sleepTimePerGuard = {}
sleepMatrix = []
for minute in [0...60]
  sleepMatrix[minute] = {}

for sleepPeriod in sleepPeriods
  sleepTimePerGuard[sleepPeriod.guardNo] ?= 0
  sleepTimePerGuard[sleepPeriod.guardNo] += sleepPeriod.end - sleepPeriod.start
  for minute in [sleepPeriod.start...sleepPeriod.end]
    sleepMatrix[minute][sleepPeriod.guardNo] ?= 0
    sleepMatrix[minute][sleepPeriod.guardNo]++

# Find worst guard
worstGuard = _.maxBy(_.toPairs(sleepTimePerGuard), 1)[0]
console.log "worstGuard: #{worstGuard}"

maxSleep = 0
worstMinute = null
for minute in [0...60]
  if sleepMatrix[minute][worstGuard] > maxSleep
    maxSleep = sleepMatrix[minute][worstGuard]
    worstMinute = minute

console.log "A: #{worstGuard * worstMinute}"

## Find worst minute (and by whom)
maxSleep = 0
worstGuard = null
worstMinute = null
for minute in [0...60]
  for guard, sleepTime of sleepMatrix[minute]
    if sleepMatrix[minute][guard] > maxSleep
      maxSleep = sleepMatrix[minute][guard]
      worstGuard = guard
      worstMinute = minute

console.log "B: #{worstGuard * worstMinute}"
