fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

inputs = aoc.parseIntArray(fs.readFileSync('./data/day8.txt'), ' ')

index = 0
read = ->
  inputs[index++]

console.log inputs

readNode = ->
  nbChilds = read()
  nbMetadata = read()
  childs = []
  childs.push(readNode()) for x in [0...nbChilds]
  metadata = []
  metadata.push(read()) for x in [0...nbMetadata]
  return {
    nbChilds
    childs
    metadata
  }

root = readNode()

console.log root

countMetadata = (node) ->
  childMetadataLength = 0
  childMetadataLength += countMetadata(child) for child in node.childs
  return _.sum(node.metadata) + childMetadataLength

console.log "A: " + countMetadata(root)

countPartTwo = (node)->
  return _.sum(node.metadata) if node.childs.length == 0
  childValue = 0
  for metadataValue in node.metadata
    childValue += countPartTwo(node.childs[metadataValue-1]) if node.childs[metadataValue-1]?
  return childValue

console.log "B: " + countPartTwo(root)
