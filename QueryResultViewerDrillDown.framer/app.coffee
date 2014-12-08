# build a top level layer to be the scrolling table container
tableContainer = new Layer({y:100, width:Screen.width/2, height:500})
tableContainer.scroll = true
tableContainer.centerX()

# define a prototypical cell
class Cell
  constructor: (@superLayer,@offset,@name,@color) ->

    # basic layer setup
    cell = new Layer
      superLayer: @superLayer
      y: @offset
      width: Screen.width/2
      height: 50
    cell.name = @name
    cell.clip = false
    cell.sendToBack()

    # styling
    cell.backgroundColor = color
    cell.shadowColor = 'rgba(0,0,0,0.2)'
    cell.shadowY = 1.5
    cell.shadowBlur = 1.5
    cell.style.border = '1px solid #F9F9F9'

    # subCells
    cell.subCells = []

    return cell




# define a cell factory class to build cells
class CellFactory
  constructor: (@superLayer) ->

    @cells = []
    @offset = 0
    @pushOffset = 153

  updateOffsets: ->
    @offset += 51
    @pushOffset += 51

  addStates: (cell) ->
    cell.states.add({
      active: {y: @offset}
      pushedDown: {y: @pushOffset}
      pushedDown2x: {y: @pushOffset * 2}
    })

  buildCells: (N,color) ->
    numCells = N + 1
    while numCells -= 1
      cell = new Cell(@superLayer,@offset,@cells.length,color)

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

        # handle sub cells
        for c in cells
          for subCell in c.subCells
            subCell.states.switch('default')
        subCell.states.switch('pushedDown')for subCell in layer.subCells if not active


      # add the cell to the cells array
      @cells.push(cell)

      # update the offsets
      @updateOffsets()

class SubCellFactory extends CellFactory
  constructor: (@superLayer,@parentCell)->
    @cells = []
    @offset = @parentCell.y
    @pushOffset = @offset + 51

  updateOffsets: ->
    @pushOffset += 51
    @offset += 0
  buildCells: (N,color)->
    super(N,color)
    @parentCell.subCells = @cells


# add subLayers to navigate
TopLevelCellFactory = new CellFactory(tableContainer)
TopLevelCellFactory.buildCells(100,'white')

for cell in TopLevelCellFactory.cells
  SecondCellFactory = new SubCellFactory(tableContainer,cell)
  SecondCellFactory.buildCells(3,'rgba(200,200,200,1)');
