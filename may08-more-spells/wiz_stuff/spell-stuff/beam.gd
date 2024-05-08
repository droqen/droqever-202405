extends Node2D

var life : int = 100
var horizontal : bool = true
func setup(mincellx, maxcellx, mincelly, maxcelly):
	var posx = (mincellx+maxcellx) * 5 # 10/2
	var posy = (mincelly+maxcelly) * 5 # 10/2
	var widthx = (maxcellx-mincellx+1) * 10
	var heighty = (maxcelly-mincelly+1) * 10
	position = Vector2(posx + 5, posy + 5)
	$beamscale/ColorRect.rect_size = Vector2(widthx,heighty)
	$beamscale/ColorRect.rect_position = Vector2(-widthx/2,-heighty/2)
	var r = RectangleShape2D.new()
	r.extents.x = widthx/2
	r.extents.y = heighty/2
	$CollisionShape2D.shape = r

	prints("spawned a beam @",posx,posy)
	return self

func setup_from_sourcepos_and_maze(
		sourcepos : Vector2,
		maze : NavdiFlagMazeMaster,
		horizontal : bool):
	self.horizontal = horizontal
	var castercell = maze.world_to_map(sourcepos)
	var mincellx = castercell.x
	var maxcellx = castercell.x
	var mincelly = castercell.y
	var maxcelly = castercell.y
	if horizontal:
		var y = castercell.y
		for x in range(mincellx, 0-1, -1):
			if is_cell_wall(maze,x,y):
				if try_break_wall(maze,x,y): pass
				else: break
			else: maze.set_cell(x, y, 0) # delete all background tiles.
			mincellx = x
		for x in range(maxcellx, 18):
			if is_cell_wall(maze,x,y):
				if try_break_wall(maze,x,y): pass
				else: break
			else: maze.set_cell(x, y, 0) # delete all background tiles.
			maxcellx = x
	else:
		var x = castercell.x
		for y in range(mincelly, 0-1, -1):
			if is_cell_wall(maze,x,y):
				if try_break_wall(maze,x,y): pass
				else: break
			else: maze.set_cell(x, y, 0) # delete all background tiles.
			mincelly = y
		for y in range(maxcelly, 18):
			if is_cell_wall(maze,x,y):
				if try_break_wall(maze,x,y): pass
				else: break
			else: maze.set_cell(x, y, 0) # delete all background tiles.
			maxcelly = y
	return self.setup(mincellx, maxcellx, mincelly, maxcelly)

func is_cell_wall(maze : NavdiFlagMazeMaster, x, y):
	return maze.get_cellvalue_flag(maze.get_cell(x, y)) == 1
func try_break_wall(maze : NavdiFlagMazeMaster, x, y) -> bool:
	match maze.get_cell(x, y):
		4:
			maze.set_cell(x, y, 5)
			return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if life > 0:
		life -= 1
		if life > 80:
			if horizontal: $beamscale.scale.y = randf()
			else: $beamscale.scale.x = randf()
		else:
			$CollisionShape2D.disabled = true
			if horizontal: $beamscale.scale.y = life / 80.0
			else: $beamscale.scale.x = life / 80.0
	else: queue_free()
