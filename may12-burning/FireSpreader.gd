extends Node2D

onready var maze = $"../maze"

var to_next_fire_step : int = 100

func _ready():
	randomize()
	var grasses = maze.get_used_cells_by_id(1)
	grasses.shuffle()
	for i in range(6):
		$bank.spawn("fire", $fires).setup(maze,grasses[i])

func _physics_process(_delta):
	if to_next_fire_step > 0:
		to_next_fire_step -= 1
	elif $fires.get_child_count() == 0:
			$Label.show()
			$Label2.show()
	else:
		to_next_fire_step = 50 + 100 % randi()
		for fire in $fires.get_children():
			var dirs = [
				Vector2.LEFT,
				Vector2.RIGHT,
				Vector2.DOWN,
				Vector2.UP,
			]
			if randf() < 0.33:
				dirs.append(Vector2(randi()%5-2,randi()%5-2)) # random big 'jump'
			if randf() < 0.66:
				dirs.append(Vector2(randi()%3-1,randi()%3-1)) # random small 'jump'
			if randf() < 0.66:
				dirs.append(Vector2(randi()%3-1,randi()%3-1)) # random small 'jump'
			dirs.shuffle()
			dirs.pop_back()
			dirs.pop_back()
			for dir in dirs:
				var cell2 = fire._cell + dir
				if not maze.get_bodies(cell2):
					match maze.get_cellv(cell2):
						1,4,8:
							$bank.spawn("fire", $fires).setup(maze,cell2)
