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
            x: objectCenter.x - (@offset * Math.sin(@angle)) - @size / 2,
            y: objectCenter.y - (@offset * Math.cos(@angle)) - @size / 2,
            opacity: 1
          }
      });

    return bubble

class Expander
  constructor: (@parent, @objectCenter, @size, @numSubBubbles) ->
    @mainBubble = new Bubble(@parent, @objectCenter, @size, "blue", true)
    @northBubble = new Bubble(@parent, @objectCenter, Math.random() * @size / 2 + @size / 5, "red", false, @size, 0);
    @southBubble = new Bubble(@parent, @objectCenter, Math.random() * @size / 2 + @size / 5, "red", false, @size, 2 * Math.PI / 4);
    @westBubble = new Bubble(@parent, @objectCenter, Math.random() * @size / 2 + @size / 5, "red", false, @size, 2 * Math.PI / 4 * 2);
    @eastBubble = new Bubble(@parent, @objectCenter, Math.random() * @size / 2 + @size / 5, "red", false, @size, 2 * Math.PI / 4 * 3);

    @angleIncrement = 2 * Math.PI / @numSubBubbles

    @subBubbles = []
    for i in [0..@numSubBubbles]
      @subBubbles.push(new Bubble(@parent, @objectCenter, Math.random() * @size / 2 + @size / 5, "red", false, @size, @angleIncrement * i))

    @mainBubble.bringToFront()

    that = @
    @mainBubble.on Events.Click, ->
      that.mainBubble.states.next()
      for subBubble in that.subBubbles
        subBubble.states.next()

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
for i in [0..gridX]
  for j in [0..gridY]
    objectCenter = {
      x: Screen.width / 2 - gridSpacer + gridSpacer * i,
      y: Screen.height / 2 - gridSpacer + gridSpacer * j
    }
    new Expander(container,objectCenter,Math.random() * 50 + 20, Math.round(Math.random() * 7) + 2)
