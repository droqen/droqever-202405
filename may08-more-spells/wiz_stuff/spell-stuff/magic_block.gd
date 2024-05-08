extends StaticBody2D

enum {
	UNINITIALIZED = 100,
	HERE,
	GONE,
}

var cell : Vector2
var maze : NavdiFlagMazeMaster
var life : int = 40

onready var blockst = TinyState.new(UNINITIALIZED, self, "_on_blockst")
func _on_blockst(then,now):
	match then:
		HERE:
			if maze.get_cellv(cell) == 6: maze.set_cellv(cell, 8)
	match now:
		UNINITIALIZED:
			hide()
			$CollisionShape2D.disabled = true
		HERE:
			hide()
			maze.set_cellv(cell, 6)
			$CollisionShape2D.disabled = true
#			$SheetSprite.setup([6])
		GONE:
			show()
			life = 40
			$CollisionShape2D.disabled = true
			$SheetSprite.setup([7])

func setup_safely_pushing_caster(cell : Vector2, caster : Node2D, maze : NavdiFlagMazeMaster):
	self.cell = cell
	self.maze = maze
	self.position = maze.map_to_center(cell)
	
	if maze.is_flag_solid(maze.get_cellvalue_flag(maze.get_cellv(cell))):
		disintegrate()
		return self# failed to place
	
	if cell == maze.world_to_map(caster.position):
		var possible_places = [
			cell + Vector2.UP,
			cell + Vector2.RIGHT,
			cell + Vector2.LEFT,
			cell + Vector2.DOWN,
		]
		if randf() < 0.5:
			possible_places[1].x *= -1
			possible_places[2].x *= -1
		var safe_cell = null
		for cell2 in possible_places:
			if is_cell_outside_map(cell2): continue # nope, not allowed
			if maze.is_flag_solid(maze.get_cellvalue_flag(maze.get_cellv(cell2))):
				continue # nope, not allowed
			else:
				safe_cell = cell2 # safe!
				break
		if safe_cell:
			caster.position = maze.map_to_center(safe_cell)
		else:
			disintegrate()
			return self# failed to place
	
	if get_tree().get_nodes_in_group("OnlyMagicBlock"):
		disintegrate()
		return self#a magic block already exists, failed to place
	
#	get_tree().call_group("OnlyMagicBlock", "disintegrate")
		# disintegrate all previously existing magic blocks
	add_to_group("OnlyMagicBlock")
	blockst.goto(HERE)
	return self
func disintegrate():
	blockst.goto(GONE) # nope
func _physics_process(_delta):
	if blockst.id == GONE:
		if life > 0:
			life -= 1
			if life % 8 > 4: hide()
			else: show()
		else: queue_free()

func is_cell_outside_map(cell):
	return cell.x < 0 or cell.x >= 18 or cell.y < 0 or cell.y >= 18
