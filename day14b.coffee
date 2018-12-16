fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

elfs = [{
  value: 3
}, {
  value: 7
}
]

elfs[0].previous = elfs[0].next = elfs[1]
elfs[1].previous = elfs[1].next = elfs[0]

tail = elfs[1]
nbRecipes = 2
input = "556061".split('').map (c)->parseInt(c)
matchPointer = 0

console.log input

pushRecipe = (recipeValue) ->
  newRecipe = {
    value: recipeValue
    next: tail.next
    previous: tail
  }
  tail.next.previous = newRecipe
  tail.next = newRecipe
  tail = newRecipe
  nbRecipes++

  if recipeValue != input[matchPointer]
    matchPointer = 0
  if recipeValue == input[matchPointer]
    matchPointer++
    if matchPointer == input.length
      console.log "B: " + (nbRecipes - input.length)
      process.exit( 0 )

printRecipes = ->
  log = []
  node = tail.next
  for x in [0...nbRecipes]
    if node == elfs[0]
      log.push "(#{node.value})"
    else if node == elfs[1]
      log.push "[#{node.value}]"
    else
      log.push node.value
    node = node.next
  return log.join(' ')

while true
  total = _.sumBy elfs, 'value'
  recipe1 = Math.floor(total / 10)
  recipe2 = total % 10
  pushRecipe(recipe1) if recipe1 != 0
  pushRecipe(recipe2)

  for elfNo in [0..1]
    elfs[elfNo] = elfs[elfNo].next for x in [0..elfs[elfNo].value]

#  console.log printRecipes()


last10 = ""
for x in [1..10]
  last10 = targetNodeStart.value + last10
  targetNodeStart = targetNodeStart.previous
