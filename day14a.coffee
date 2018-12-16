fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

elfs = [ {
  value: 3
},{
  value: 7
}
]

elfs[0].previous = elfs[0].next = elfs[1]
elfs[1].previous = elfs[1].next = elfs[0]

tail = elfs[1]
nbRecipes = 2
targetRecipes = 556061
targetNodeStart = null

pushRecipe = ( recipeValue ) ->
  newRecipe = {
    value: recipeValue
    next: tail.next
    previous: tail
  }
  tail.next.previous = newRecipe
  tail.next = newRecipe
  tail = newRecipe
  nbRecipes++
  targetNodeStart = newRecipe if nbRecipes == targetRecipes + 10

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

while nbRecipes < targetRecipes + 10
  total = _.sumBy elfs, 'value'
  recipe1 = Math.floor(total/10)
  recipe2 = total % 10
  pushRecipe( recipe1 ) if recipe1 != 0
  pushRecipe( recipe2 )

  for elfNo in [0..1]
    elfs[elfNo] = elfs[elfNo].next for x in [0..elfs[elfNo].value]

#  console.log printRecipes()


last10 = ""
for x in [1..10]
  last10 = targetNodeStart.value + last10
  targetNodeStart = targetNodeStart.previous

console.log "A: #{last10}"
