fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

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

instructionMap =
  addr: addr
  addi: addi
  mulr: mulr
  muli: muli
  banr: banr
  bani: bani
  borr: borr
  bori: bori
  setr: setr
  seti: seti
  gtir: gtir
  gtri: gtri
  gtrr: gtrr
  eqir: eqir
  eqri: eqri
  eqrr: eqrr

instructions = aoc.parse2DArray(fs.readFileSync('./data/day21.txt'), ' ')
instructions.forEach (instruction)->
  instruction.original = instruction.join(' ')
  instruction[0] = instructionMap[instruction[0]]
  instruction[x] = parseInt(instruction[x]) for x in [1..3]

registers = [0, 0, 0, 0, 0, 0]

aOutput = false
values = []
lastValue = null

ip_register = 1
while registers[ip_register] >= 0 and registers[ip_register] < instructions.length
  # Optimize 17 - 26
  if registers[ip_register] == 17
    registers[2] = registers[4] = Math.floor( registers[2] / 256 )
    registers[3] = 1
    registers[ip_register] = 26
  else if registers[ip_register] == 28
    if not aOutput
      console.log "A: " + registers[5]
      aOutput = true

    # Part B
    values[registers[5]] ?= 0
    values[registers[5]]++
    if values[registers[5]] == 2
      console.log "B: " + lastValue
      process.exit( 0 )

    lastValue = registers[5]

    registers[ip_register] = 5
  else
    instruction = instructions[registers[ip_register]]
    instruction[0](registers, instruction[1], instruction[2], instruction[3])

  registers[ip_register]++

