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

###
# 0 - seti 123 0 5
r5 = 123

# 1 - bani 5 456 5
r5 &= 456

# 2 - eqri 5 72 5
r5 = if r5 == 72 then 1 else 0

# 3 - addr 5 1 1
IP += r5

# 4 - seti 0 0 1
IP = 0

# 5 - seti 0 9 5               #| r5 = 0
r5 = 0                         #|
                               #| while true :outerloop
# 6 - bori 5 65536 2           #|
r2 = r5 | 0x10000              #|   r2 = r5 | 0x10000
                               #|
# 7 - seti 7571367 9 5         #|
r5 = 0x7387A7                  #|   r5 = 0x7387A7
                               #|
# 8 - bani 2 255 4             #||  while true
r4 = r2 & 0xFF                 #||    r4 = r2 & 0xFF                        reg2 = ((reg2 + (reg1 & 0xff)) * 65899) & 0xffffff
                               #||
# 9 - addr 5 4 5               #||
r5 += r4                       #||    r5 += r4
                               #||
# 10 - bani 5 16777215 5       #||
r5 &= 0xFFFFFF                 #||    r5 &= 0xFFFFFF
                               #||
# 11 - muli 5 65899 5          #||
r5 *= 65899                    #||    r5 *= 0x1016B
                               #||
# 12 - bani 5 16777215 5       #||
r5 &= 0xFFFFFF                 #||    r5 &= 0xFFFFFF
                               #||
# 13 - gtir 256 2 4            #||
r4 = if 256 > r2 then 1 else 0 #||    if r2 < 0x100
                               #||      if r5 == r0
# 14 - addr 4 1 1              #||        exit!
IP += r4                       #||      else
                               #||        continue :outerloop
# 15 - addi 1 1 1              #||
IP++                           #||
                               #||
# 16 - seti 27 1 1             #||
IP = 27                        #||
                               #||
# 17 - seti 0 2 4              #||
r4 = 0                         #||    r4 = 0                                            |  r2 = Math.floor( r2 / 256 )
                               #||                                                      |
# 18 - addi 4 1 3              #|||   while true                          1111 1111     |
r3 = r4 + 1                    #|||     r3 = (r4 + 1) * 0x100           1 1111 1110     |
                               #|||                                    10 1111 1101     |
# 19 - muli 3 256 3            #|||                                    11 1111 1100     |
r3 *= 256                      #|||                                   100 1111 1011     |
                               #|||                                                     |
# 20 - gtrr 3 2 3              #|||                                                     |
r3 = if r3 > r2 then 1 else 0  #|||     if r3 > r2                                      |
                               #|||       break                                         |
# 21 - addr 3 1 1              #|||     else                                            |
IP += r3                       #|||       r4++                                          |
                               #|||                                                     |
# 22 - addi 1 1 1              #|||                                                     |
IP++                           #|||                                                     |
                               #|||                                                     |
# 23 - seti 25 6 1             #|||                                                     |
IP = 25                        #|||                                                     |
                               #|||                                                     |
# 24 - addi 4 1 4              #|||                                                     |
r4++                           #|||                                                     |
                               #|||                                                     |
# 25 - seti 17 8 1             #|||                                                     |
IP = 17                        #|||                                                     |
                               #||                                                      |
# 26 - setr 4 6 2              #||                                                      |
r2 = r4                        #||    r2 = r4                                           |
                               #||
# 27 - seti 7 4 1              #||
IP = 7                         #||
                               #|
# 28 - eqrr 5 0 4              #|
r4 = if r5 == r0 then 1 else 0 #|
                               #|
# 29 - addr 4 1 1              #|
IP += r4                       #|
                               #|
# 30 - seti 5 5 1              #|
IP = 5                         #|
###

count = 0

# IP = r1
r0 = 0
IP = 0
r2 = 0
r3 = 0
r4 = 0
r5 = 0

r5 = 0

min = Number.MAX_VALUE

while true
  count++

#  console.log "IP 6, [#{[r0, 6, r2, r3, r4, r5].join(', ')}]"
  r2 = r5 | 0x10000

  r5 = 0x7387A7

  subloop = () ->

    # r2 is divided by 256 on every loop
    while true
      count++

#      console.log "IP 8, [#{[r0, 8, r2, r3, r4, r5].join(', ')}]"
      r4 = r2 & 0xFF

#      console.log "IP 9, [#{[r0, 9, r2, r3, r4, r5].join(', ')}]"
      r5 += r4

#      console.log "IP 10, [#{[r0, 10, r2, r3, r4, r5].join(', ')}]"
      r5 &= 0xFFFFFF

#      console.log "IP 11, [#{[r0, 11, r2, r3, r4, r5].join(', ')}]"
      r5 *= 0x1016B

#      console.log "IP 12, [#{[r0, 12, r2, r3, r4, r5].join(', ')}]"
      r5 &= 0xFFFFFF

#      console.log "IP 13, [#{[r0, 13, r2, r3, r4, r5].join(', ')}]"
      if r2 < 0x100
        if r5 < min
          min = r5
          console.log "New min " + r5
        return

      r2 = r4 = Math.floor( r2 / 256 )
      r3 = 1

  subloop()
