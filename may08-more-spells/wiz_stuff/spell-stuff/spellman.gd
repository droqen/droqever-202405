extends Node

onready var magicfx = $"../magicfx"
onready var bank = $spellbank

var maze : NavdiFlagMazeMaster

#func get_maze() -> NavdiFlagMazeMaster: return maze

func _ready():
	add_to_group("SPELLMEN")

func castspell(spellname, caster=null, target=null):
	prints("castspell", spellname, caster, target)
	if caster == null:
		print("castspell failed (no caster provided)")
		return
#	var maze = get_maze()
	if maze == null:
		print("castspell failed (no maze found)")
		return
	match spellname:
		"DUOTO", "AUOTO":
			bank.spawn("beam", magicfx).setup_from_sourcepos_and_maze(caster.position, maze, true)
		"WUOTO", "SUOTO":
			bank.spawn("beam", magicfx).setup_from_sourcepos_and_maze(caster.position, maze, false)
		"FLIGHTED":
			bank.spawn("pop", magicfx, caster.position).setup()
			caster.enable_wings()
		"BOLES":
			bank.spawn("pop", magicfx, Vector2(180,180) - caster.position).setup()
		"BOLESDUOTO", "BOLESAUOTO":
			bank.spawn("beam", magicfx).setup_from_sourcepos_and_maze(Vector2(180,180) - caster.position, maze, true)
		"BOLESWUOTO", "BOLESSUOTO", "BOLESUOTO":
			bank.spawn("beam", magicfx).setup_from_sourcepos_and_maze(Vector2(180,180) - caster.position, maze, false)
		"LESWEL":
			var cell = maze.world_to_map(caster.position)
			var cellpos = maze.map_to_center(cell)
			bank.spawn("pop", magicfx, cellpos).setup()
			bank.spawn("magic_block", magicfx).setup_safely_pushing_caster(cell, caster, maze)
		"LEWSEL":
			# despawn magic block?
			get_tree().call_group("OnlyMagicBlock", "disintegrate")
		"BOLESWEL":
			var cell = maze.world_to_map(Vector2(180,180) - caster.position)
			var cellpos = maze.map_to_center(cell)
			bank.spawn("pop", magicfx, cellpos).setup()
			bank.spawn("magic_block", magicfx).setup_safely_pushing_caster(cell, caster, maze)
			
