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

instructions = aoc.parse2DArray(fs.readFileSync('./data/day19.txt'), ' ')
instructions.forEach (instruction)->
  instruction.original = instruction.join(' ')
  instruction[0] = instructionMap[instruction[0]]
  instruction[x] = parseInt(instruction[x]) for x in [1..3]

run = ( registers ) ->
  count = 0
  ip_register = 5
  while registers[ip_register] >= 0 and registers[ip_register] < instructions.length and count < 100
    count++
    instruction = instructions[registers[ip_register]]
    console.log "IP #{(''+registers[ip_register]).padStart(2)}, [#{registers.join(', ')}], {#{(''+instruction[0]).match('return registers\\[c\\] = (.*);')[1]}} with #{instruction[1..5].join(', ')}"
    instruction[0](registers, instruction[1], instruction[2], instruction[3])
    registers[ip_register]++
  registers[ip_register]--
  registers[0]

console.log "A: " + run([0, 0, 0, 0, 0, 0])
