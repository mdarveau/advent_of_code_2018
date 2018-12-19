###
r0 = 1
r1 = 0
r2 = 0
r3 = 0
r4 = 0
IP = 0

# 0 - addi 5 16 5  -- Jump to init (#17)
IP += 16

# 1 - seti 1 1 2   -- Start of program after init                  # | r0 = 0
r2 = 1                                                             # | r4 = 10551293
                                                                   # |
# 2 - seti 1 8 1   -- Start of outer loop to #15                   # | r2 = 1
r1 = 8                                                             # | while r2 <= r4
                                                                   # |
# r0 = 0, r1 = 8, r2 = 1, r3 = 10550400 and r4 = 10551293          # |  r1 = 8
                                                                   # |
# 3 - mulr 2 1 3             -- Start of inner loop to #11         # |  while r1 <= r4
r3 = r2 * r1                                                       # |    r3 = r2 * r1
                                                                   # |
# 4 - eqrr 3 4 3         # |                                       # |    # Increment r0 if r4 is divisible by r1 (8)
r3 = r3 == r4 ? 1 : 0    # | if r3 == r4                           # |    if r3 == r4
                         # |   r0 += r2                            # |      r0 += r2
# 5 - addr 3 5 5         # |                                       # |
IP += r3                 # |                                       # |    r1++
                         # |                                       # |
# 6 - addi 5 1 5         # |                                       # |
IP++                     # |                                       # |
                         # |                                       # |
# 7 - addr 2 0 0         # |                                       # |
r0 += r2                 # |                                       # |
                         # |                                       # |
# 8 - addi 1 1 1                                                   # |
r1++                                                               # |
                                                                   # |
# 9 - gtrr 1 4 3             -- Exit criteria of inner loop:       # |
r3 = r1 > r4 ? 1 : 0                                               # |
                                                                   # |
# 10 - addr 5 3 5                                                  # |
IP += r3                                                           # |
                                                                   # |
# 11 - seti 2 6 5            -- End of inner loop from #3          # |
IP = 2                                                             # |
                                                                   # |
# 12 - addi 2 1 2                                                  # |
r2 += 1                                                            # |   r2++
                                                                   # |
# 13 - gtrr 2 4 3  -- Exit criteria of outer loop                  # |
r3 = r2 > r4 ? 1 : 0                                               # |
                                                                   # |
# 14 - addr 3 5 5                                                  # |
IP += r3                                                           # |
                                                                   # |
# 15 - seti 1 2 5  -- End of outer loop from #2                    # |
IP = 1                                                             # |
                                                                   # |
# 16 - mulr 5 5 5   -- End of program, output r0                   # |
IP *= IP                                                           # |
                                                                   # |
# 17 - addi 4 2 4   -- Program start (from #0)                     # |
r4 += 2

# 18 - mulr 4 4 4
r4 *= r4

# 19 - mulr 5 4 4
r4 += IP

# 20 - muli 4 11 4
r4 *= 11

# 21 - addi 3 2 3
r3 += 2

# 22 - mulr 3 5 3
r3 *= IP

# 23 - addi 3 13 3
r3 += 13

# 24 - addr 4 3 4
r4 += r3

# 25 - addr 5 0 5
IP += r0

# 26 - seti 0 8 5  -- Skipped on part b init
IP = 0

# 27 - setr 5 5 3
r3 = IP

# 28 - mulr 3 5 3
r3 *= IP

# 29 - addr 5 3 3
r3 += IP

# 30 - mulr 5 3 3
r3 *= IP

# 31 - muli 3 14 3
r3 *= 14

# 32 - mulr 3 5 3
r3 *= 5

# 33 - addr 4 3 4
r4 += r3

# 34 - seti 0 9 0
r0 = 0

# 35 - seti 0 9 5  -- End of init. At this point r0 = 0, r3 = 10550400 and r4 = 10551293
IP = 0
###

#
# Decompiled program... still too slow...
#

# r0 = 0
# r4 = 10551293
# r2 = 1
# while r2 <= r4
#   r1 = 8
#   while r1 <= r4
#     count++
#     r3 = r2 * r1
#     if r3 == r4
#       r0 += r2
#     r1++
#   r2++

#
# Sum of divisors!
#
r0 = 0
for x in [1..10551293]
  if 10551293 % x == 0
    r0 += x

console.log "B: #{r0}"
