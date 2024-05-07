extends Node2D

signal room_changed

func _ready():
	add_to_group("ROOMMEN")

func launch_edge_room(target_room_or_path, direction, mover):
	for child in get_children():
		remove_child(child)
		child.queue_free()
	var new_room = null
	if target_room_or_path is String:
		get_tree().paused = true
		new_room = load(target_room_or_path).instance()
	elif target_room_or_path is PackedScene:
		new_room = target_room_or_path.instance()
	elif target_room_or_path is Node2D:
		new_room = target_room_or_path
	else:
		push_error("launch_edge_room cannot handle given target room or path: "+str(target_room_or_path))
		return # fail'd
	add_child(new_room)
	new_room.owner = owner if owner else self
	mover.position -= direction * 180
	if mover.velocity.y > 0: mover.velocity.y = 0
	emit_signal("room_changed")
	get_tree().paused = false
