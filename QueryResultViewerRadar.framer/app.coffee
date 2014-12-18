class Bubble
  constructor: (@parent,@objectCenter, @size, @color, @isMain = false, @offset = 100, @angle = null) ->
    bubble = new Layer({
      superLayer: @parent,
      height: @size,
      width: @size,
      x: objectCenter.x - @size / 2,
      y: objectCenter.y - @size / 2,
      borderRadius: @size / 2,
      backgroundColor: @color,
      opacity: 0

    });

    bubble.objectCenter = @objectCenter
    bubble.opacity = 1 if @isMain

    if @isMain
      bubble.states.animationOptions = {
          time: 0.2
      }
    else
      bubble.states.animationOptions = {
          curve: "spring(300, 10, 0)",
          time: 0.2
      }

    if @isMain
      bubble.states.add({
          open: {
            opacity: 0.25
          }
      });
    else
      bubble.states.add({
          open: {
            x: bubble.objectCenter.x - (@offset * Math.sin(@angle)) - @size / 2,
            y: bubble.objectCenter.y - (@offset * Math.cos(@angle)) - @size / 2,
            opacity: 1
          }
      });

    bubble.recenter = (objectCenter) =>

      bubble.objectCenter = objectCenter

      if @isMain
        bubble.states._states.default = {
          x: bubble.objectCenter.x - @size / 2,
          y: bubble.objectCenter.y - @size / 2,
          opacity: 1
          }
        bubble.states._states.open = {
          x: bubble.objectCenter.x - @size / 2,
          y: bubble.objectCenter.y - @size / 2,
          opacity: 0.25
          }
      else
        bubble.states._states.default = {
          x: bubble.objectCenter.x - @size / 2,
          y: bubble.objectCenter.y - @size / 2,
          opacity: 0
          }
        bubble.states._states.open = {
          x: bubble.objectCenter.x - (@offset * Math.sin(@angle)) - @size / 2,
          y: bubble.objectCenter.y - (@offset * Math.cos(@angle)) - @size / 2,
          opacity: 1
          }

    return bubble


class Expander
  constructor: (@parent, @objectCenter, @size, @numSubBubbles) ->
    @mainBubble = new Bubble(@parent, @objectCenter, @size, "#00ccff", true)
    @mainBubble.id = @id
    @angleIncrement = 2 * Math.PI / @numSubBubbles

    @subBubbles = []
    for i in [0..@numSubBubbles]
      @subBubbles.push(new Bubble(@parent, @objectCenter, Math.random() * @size / 2 + @size / 5, "#ff9933", false, @size, @angleIncrement * i))

    @mainBubble.bringToFront()

    that = @
    @mainBubble.on Events.Click, ->
      that.mainBubble.states.next()
      for subBubble in that.subBubbles
        subBubble.states.next()

  expand: () =>
    @mainBubble.states.switch('open')
    bubble.states.switch('open') for bubble in @subBubbles

  contract: () =>
    @mainBubble.states.switch('default')
    bubble.states.switch('default') for bubble in @subBubbles

  recenter: (objectCenter) =>
    @mainBubble.recenter(objectCenter)
    @mainBubble.states.switch(@mainBubble.states.current)

    for subBubble in @subBubbles
      subBubble.states.animationOptions = {
          curve: "linear",
          time: 0.2
      }
      subBubble.recenter(objectCenter)
      subBubble.states.switch(subBubble.states.current)
      subBubble.states.animationOptions = {
          curve: "spring(300, 10, 0)",
          time: 0.2
      }




container = new Layer({
  height: Screen.height,
  width: Screen.width,
  backgroundColor: 'rgba(0,0,0,0)'
})
container.scroll = true

objectCenter = {x: Screen.width / 2, y: Screen.height / 2}

gridX = 2
gridY = 20
gridSpacer = 200
expanders = []
for i in [0..gridX]
  for j in [0..gridY]
    objectCenter = {
      x: Screen.width / 2 - gridSpacer + gridSpacer * i,
      y: Screen.height / 2 - gridSpacer + gridSpacer * j
    }
    expanders.push(new Expander(container,objectCenter,Math.random() * 50 + 20, Math.round(Math.random() * 8) + 2))


expandAll = () ->
  expander.expand() for expander in expanders

contractAll = () ->
  expander.contract() for expander in expanders

sortBySize = () ->
  sortedExpanders = _.sortBy(expanders,(e) -> e.size).reverse()
  ind = 0
  for i in [0..gridY]
    for j in [0..gridX]
      objectCenter = {
        y: Screen.height / 2 - gridSpacer + gridSpacer * i,
        x: Screen.width / 2 - gridSpacer + gridSpacer * j
      }
      sortedExpanders[ind].recenter(objectCenter)
      ind += 1

sortByID = () ->
  sortedExpanders = _.sortBy(expanders,(e) -> e.mainBubble._id).reverse()
  ind = 0
  for i in [0..gridY]
    for j in [0..gridX]
      objectCenter = {
        y: Screen.height / 2 - gridSpacer + gridSpacer * i,
        x: Screen.width / 2 - gridSpacer + gridSpacer * j
      }
      sortedExpanders[ind].recenter(objectCenter)
      ind += 1

# UI buttons
expandButton = new Layer({
  height: 40,
  width: 100,
  x: Screen.width / 2 + 150,
  y: 50,
  borderRadius: 20,
  backgroundColor: '#999999'
})
Utils.labelLayer(expandButton, 'Expand All')
expandButton.on Events.Click, ->
  expandAll()

sortButton = new Layer({
  height: 40,
  width: 100,
  x: Screen.width / 2 - 50,
  y: 50,
  borderRadius: 20,
  backgroundColor: '#999999'
})
sortButton.state = 'id'
Utils.labelLayer(sortButton, 'Sort')
sortButton.on Events.Click, ->
  if sortButton.state == 'id'
    sortButton.state = 'size'
    sortBySize()
  else
    sortButton.state = 'id'
    sortByID()

contractButton = new Layer({
  height: 40,
  width: 100,
  x: Screen.width / 2 - 250,
  y: 50,
  borderRadius: 20,
  backgroundColor: '#999999'
})
Utils.labelLayer(contractButton, 'contract All')

contractButton.on Events.Click, ->
  contractAll()
