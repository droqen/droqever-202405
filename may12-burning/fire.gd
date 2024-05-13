extends NavdiMazeKineBody

var hp : int = 9
var burning : int = 0

func _ready():
	burning = 150 + 300 % randi()

func setup(maze, cell):
	.setup(maze, cell)
	match maze.get_cellv(_cell):
		4:
			maze.set_cellv(_cell,6)
			$SheetSprite.position += Vector2(0, -5)
	return self

func _physics_process(_delta):
	burning -= 1
	if burning <= 0:
		queue_free()
		match maze.get_cellv(_cell):
			1,8: maze.set_cellv(_cell, 3)
			4,6:
				maze.set_cellv(_cell, 7)
				maze.set_cellv(_cell+Vector2.UP, 9)
	# in the meantime, spread

func extinguish(damage : int):
	hp -= damage
	if hp <= 0:
		match maze.get_cellv(_cell):
			6:
				maze.set_cellv(_cell, 4)
		queue_free()
