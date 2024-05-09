extends GridContainer

func _physics_process(_delta):
	var target_columns = 2 if rect_size.x>rect_size.y else 1
	if columns != target_columns:
		columns = target_columns
		update()
