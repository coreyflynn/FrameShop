# build container layers
# Sig
SigContainerLayer = new Layer
	width: 1000, height:200
SigContainerLayer.center()
SigContainerLayer.scrollVertical = true
SigContainerLayer.shadowY = 3
SigContainerLayer.shadowBlur = 3
SigContainerLayer.shadowColor = "rgba(0,0,0,0.24)"
SigContainerLayer.containerIndex = 0
SigContainerLayer.state = 'covered'
SigContainerLayer.name = 'Signatures'
SigContainerLayer.on Events.Click, ->
	ContainerClick(this)

# PertandCell
PertAndCellContainerLayer = SigContainerLayer.copy()
PertAndCellContainerLayer.containerIndex = 1
PertAndCellContainerLayer.state = 'covered'
PertAndCellContainerLayer.name = 'Perturbagens By Cell Line'
PertAndCellContainerLayer.on Events.Click, ->
	ContainerClick(this)

# Pert
PertContainerLayer = SigContainerLayer.copy()
PertContainerLayer.containerIndex = 2
PertContainerLayer.state = 'covered'
PertContainerLayer.name = 'Perturbagens'
PertContainerLayer.on Events.Click, ->
	ContainerClick(this)

# PCL
PCLContainerLayer = SigContainerLayer.copy()
PCLContainerLayer.containerIndex = 3
PCLContainerLayer.state = 'uncovered'
PCLContainerLayer.name = 'Pharmacological Classes'
PCLContainerLayer.on Events.Click, ->
	ContainerClick(this)

containers = [SigContainerLayer,PertAndCellContainerLayer,PertContainerLayer,PCLContainerLayer]

# add images to containers
# Sig
SigImageLayer = new Layer
	x:0, y:0, width:1000, height:462, image:"images/GUTCTables_sigs.png", superLayer:SigContainerLayer

# PertAndCell
PertAndCellImageLayer = new Layer
	x:0, y:0, width:1000, height:462, image:"images/GUTCTables_pertsAndCells.png", superLayer:PertAndCellContainerLayer

# Pert
PertImageLayer = new Layer
	x:0, y:0, width:1000, height:462, image:"images/GUTCTables_perts.png", superLayer:PertContainerLayer

# Pert
PCLImageLayer = new Layer
	x:0, y:0, width:1000, height:462, image:"images/GUTCTables_PCL.png", superLayer:PCLContainerLayer

# add a layer for an indicator of table that we are looking that
TextIndicatorLayer = new Layer
	y:100, width: $(window).width()
TextIndicatorLayer.centerX()
TextIndicatorLayer.style = {
	"background": "none"
	"color": "black"
	"opacity": "0.54"
	"font-size": "3.272405em"
	"text-align": "center"
}
TextIndicatorLayer.html = "Pharmacological Classes"

# build a generic click function
ContainerClick = (container) ->
	ind = container.containerIndex
	oneLower = containers[ind - 1]
	oneHigher = containers[ind + 1]
	if container.state == 'removed'
		container.state = 'uncovered'
		oneLower.state = 'covered'
		container.animate
			curve: 'ease-in-out'
			time: 0.3
			properties:
				y: container.y - 250
				opacity: 1
		container.bringToFront()
		TextIndicatorLayer.html = container.name
		return
	if container.state == 'peek'
		container.state = 'uncovered'
		if oneHigher
			oneHigher.state = 'removed'
			oneHigher.animate
				curve: 'ease-in-out'
				time: 0.3
				properties:
					y: container.y + 350
			oneHigher.bringToFront()
		container.animate
			curve: 'ease-in-out'
			time: 0.3
			properties:
				y: container.y + 100
		TextIndicatorLayer.html = container.name
		return
	else
		if oneLower
			if container.state == 'uncovered' && oneLower.state == 'covered'
				oneLower.state = 'peek'
				oneLower.animate
					curve: 'ease-in-out'
					time: 0.3
					properties:
						y: container.y - 100
			else if container.state != 'removed'
				oneLower.state = 'covered'
				oneLower.animate
					curve: 'ease-in-out'
					time: 0.3
					properties:
						y: container.y
