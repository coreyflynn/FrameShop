# build a top level layer to be the scrolling table container
tableContainer = new Layer({y:100, width:Screen.width/2, height:500})
tableContainer.scroll = true
tableContainer.centerX()

# define a cell factory class to build cells
class CellFactory
  constructor: (@superLayer) ->

    @cells = []
    @offset = 0
    @pushOffset = 153

    @updateOffsets = () ->
      @offset += 51
      @pushOffset += 51

    @addStates = (cell) ->
      cell.states.add({
        active: {y: @offset}
        pushedDown: {y: @pushOffset}
      })

    @buildCells = (N,color) ->
      numCells = N
      while numCells -= 1
        # basic layer setup
        cell = new Layer
          superLayer: @superLayer
          y: @offset
          width: Screen.width/2
          height: 50
        cell.name = @cells.length
        cell.clip = false

        # styling
        cell.backgroundColor = color
        cell.shadowColor = 'rgba(0,0,0,0.2)'
        cell.shadowY = 1.5
        cell.shadowBlur = 1.5
        cell.style.border = '1px solid #F9F9F9'

        # states
        @addStates(cell)

        # animation options
        cell.states.animationOptions = {
            curve: "spring-dho(100, 10, 0)"
        }

        # click handler
        cells = @cells
        cell.on Events.Click, (event, layer) ->
          pushStart = layer.name + 1
          active  = layer.states.current is 'active'
          c.states.switch('default') for c in cells
          layer.states.switch('active') if not active
          layer.states.switch('default') if active
          c.states.switch('pushedDown') for c in cells[pushStart..] if not active

          #animate subLayers
          c.states.switch('pushedDown') for c in layer.subLayers


        # add the cell to the cells array
        @cells.push(cell)

        # update the offsets
        @updateOffsets()

class SubCellFactory extends CellFactory

  @pushOffset2 = 51

  @updateOffsets = () ->
    @pushOffset2 += 51

  @addStates = (cell) ->
    console.log('subcell')
    cell.states.add({
      active: {y: @offset}
      pushedDown: {y: 0}
    })






# add subLayers to navigate
TopLevelCellFactory = new CellFactory(tableContainer)
TopLevelCellFactory.buildCells(100,'white')

SecondCellFactory = new SubCellFactory(TopLevelCellFactory.cells[0])
SecondCellFactory.buildCells(4,'red');







# # Use Resources to get widths and heights of images.
# # Any images in the images folder will be added to this object.
# resource = Resources["icon.png"]
# layer = new Layer
#   image: resource.path
#   width: resource.width
#   height:resource.height
# layer.center()
#
# instructions = new Layer
#   width: Screen.width
#   height: 100
#   backgroundColor: null
#   y: Screen.height - 100
# instructions.html = "Start in app.coffee inside the project folder in your favorite text editor"
# instructions.style =
#   color: "black"
#   textAlign: "center"
#   fontFamily: "Helvetica Neue"
#   fontWeight: 100
#   padding: "5px"
#   fontSize: "20px"
