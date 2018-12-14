fs = require('fs')
_ = require('lodash')
aoc = require('./aoc_util')

data = aoc.parse2DArray(fs.readFileSync('./data/day13.txt'), '')

UP = 0
RIGHT = 1
DOWN = 2
LEFT = 3
cartDirectionChars = ['^', '>', 'v', '<']
cartDirectionVectors = [{x: 0, y: -1}, {x: 1, y: 0}, {x: 0, y: 1}, {x: -1, y: 0}]
intersectionSequence = [-1, 0, 1]

carts = []
for y in [0...data.length]
  for x in [0...data[y].length]
    direction = _.indexOf(cartDirectionChars, data[y][x])
    carts.push {x, y, direction, intersectionSequenceNo: 0} if direction != -1
    data[y][x] = '|' if direction == UP or direction == DOWN
    data[y][x] = '-' if direction == LEFT or direction == RIGHT

printTracksWithCarts = (tracks, carts) ->
  tracks = _.cloneDeep(tracks)
  for cart in carts
    tracks[cart.y][cart.x] = cartDirectionChars[cart.direction]
  aoc.print2DArray(tracks, '')

while carts.length > 1
  carts = _.sortBy carts, ['y', 'x']
  collidedCarts = []
  for cart in carts
    continue if _.find(collidedCarts, cart)?
    cart.x += cartDirectionVectors[cart.direction].x
    cart.y += cartDirectionVectors[cart.direction].y
    newTrack = data[cart.y][cart.x]
    collisionCart = _.find carts, (comparedCart)-> comparedCart != cart and comparedCart.x == cart.x and comparedCart.y == cart.y
    if collisionCart?
      collidedCarts.push cart
      collidedCarts.push collisionCart
    else if newTrack == '+'
      cart.direction += intersectionSequence[cart.intersectionSequenceNo % 3]
      cart.intersectionSequenceNo++
    else
      switch cart.direction
        when UP, DOWN
          cart.direction++ if newTrack == '/'
          cart.direction-- if newTrack == '\\'
        when LEFT, RIGHT
          cart.direction-- if newTrack == '/'
          cart.direction++ if newTrack == '\\'
    cart.direction = (cart.direction + cartDirectionVectors.length) % cartDirectionVectors.length

  carts = _.filter carts, (c) -> not _.find(collidedCarts, c)?

console.log "B: #{carts[0].x},#{carts[0].y}"
