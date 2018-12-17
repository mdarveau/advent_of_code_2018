fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

regex = /^Before: \[(.*)\]$\n^(.*)$\n^After:  \[(.*)\]$\n^$/gm;
#^(.*)$^After:  [(.*)]$

input = "" + fs.readFileSync('./data/day16a.txt')

samples = []

while data = regex.exec input
  samples.push {
    input: aoc.parseIntArray data[1], ', '
    instruction: aoc.parseIntArray data[2], ' '
    output: aoc.parseIntArray data[3], ', '
  }

addr = (registers, a, b, c) -> registers[c] = registers[a] + registers[b]
addi = (registers, a, b, c) -> registers[c] = registers[a] + b
mulr = (registers, a, b, c) -> registers[c] = registers[a] * registers[b]
muli = (registers, a, b, c) -> registers[c] = registers[a] * b
banr = (registers, a, b, c) -> registers[c] = registers[a] & registers[b]
bani = (registers, a, b, c) -> registers[c] = registers[a] & b
borr = (registers, a, b, c) -> registers[c] = registers[a] | registers[b]
bori = (registers, a, b, c) -> registers[c] = registers[a] | b
setr = (registers, a, b, c) -> registers[c] = registers[a]
seti = (registers, a, b, c) -> registers[c] = a
gtir = (registers, a, b, c) -> registers[c] = if a > registers[b] then 1 else 0
gtri = (registers, a, b, c) -> registers[c] = if registers[a] > b then 1 else 0
gtrr = (registers, a, b, c) -> registers[c] = if registers[a] > registers[b] then 1 else 0
eqir = (registers, a, b, c) -> registers[c] = if a == registers[b] then 1 else 0
eqri = (registers, a, b, c) -> registers[c] = if registers[a] == b then 1 else 0
eqrr = (registers, a, b, c) -> registers[c] = if registers[a] == registers[b] then 1 else 0

allops = [
  addr
  addi
  mulr
  muli
  banr
  bani
  borr
  bori
  setr
  seti
  gtir
  gtri
  gtrr
  eqir
  eqri
  eqrr
]

countWithThreeMatchesOrMore = 0

matches = {}
instructionMap = {}

for sample in samples
  nbMatch = 0
  for ops in allops
    registers = _.cloneDeep sample.input
    ops(registers, sample.instruction[1], sample.instruction[2], sample.instruction[3])
    if _.isEqual(registers, sample.output)
      nbMatch++
      matches[sample.instruction[0]] ?= []
      matches[sample.instruction[0]].push ops

  if nbMatch >= 3
    countWithThreeMatchesOrMore++

console.log "A: " + countWithThreeMatchesOrMore

findUniqueInstruction = ->
  for instruction, instructions of matches
    return [instruction, instructions[0]] if instructions.length == 1
  throw new Error("findUniqueInstruction")

for instruction, instructions of matches
  matches[instruction] = _.uniq(instructions)

while not _.isEqual matches, {}
  [instructionId, instructionFunction] = findUniqueInstruction()
  instructionMap[instructionId] = instructionFunction
  delete matches[instructionId]
  for instruction, instructions of matches
    matches[instruction] = _.pullAllWith(instructions, [instructionFunction], _.isEqual);

instructions = aoc.parse2DIntArray(fs.readFileSync('./data/day16b.txt'), ' ')
registers = [0, 0, 0, 0]
for instruction in instructions
  instructionMap[instruction[0]](registers, instruction[1], instruction[2], instruction[3])

console.log "B: " + registers[0]
