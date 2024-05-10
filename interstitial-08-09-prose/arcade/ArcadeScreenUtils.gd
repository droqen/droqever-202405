tool
extends Node

func setup(arcade):
	if _arcade: push_error("ArcadeScreenUtils.setup was already called this runtime.")
	_arcade = arcade

var _arcade

const BOUNDINGRECT = Rect2(10, 10, 200-10-10, 200-10-10)
const TOP = BOUNDINGRECT.position.y
const BOT = BOUNDINGRECT.position.y + BOUNDINGRECT.size.y
const LEFT = BOUNDINGRECT.position.x
const RIGHT = BOUNDINGRECT.position.x + BOUNDINGRECT.size.x

func keep_on_screen(n : Node2D):
	n.position.x = clamp(n.position.x, LEFT-5, RIGHT+5)
	n.position.y = clamp(n.position.y, TOP-5, BOT+5)

func get_off_edge_direction(position : Vector2) -> Vector2:
	var direction = Vector2.ZERO
	if position.x < LEFT:
		direction.x = -1
	if position.y < TOP:
		direction.y = -1
	if position.x > RIGHT:
		direction.x = 1
	if position.y > BOT:
		direction.y = 1
	return direction

func _load_room(room):
	var new_room = null
	if room is String:
		get_tree().paused = true # pause game during blocking load
		new_room = load(room).instance()
		get_tree().set_deferred('paused',false) # unpause after blocking load
	elif room is PackedScene:
		new_room = room.instance()
	elif room is Node2D:
		new_room = room
	else:
		push_error("launch_edge_room cannot handle given target room or path: "+str(room))
	return new_room

func launch_warp_room(room):
	var new_room = _load_room(room)
	if new_room:
		_arcade.clear_rooms()
		_arcade.set_room_instance(new_room)
func launch_edge_room(room, direction : Vector2, player : Node2D):
	var new_room = _load_room(room)
	if new_room:
		_arcade.clear_rooms()
		player.position.x = clamp(player.position.x - direction.x * BOUNDINGRECT.size.x, LEFT, RIGHT)
		player.position.y = clamp(player.position.y - direction.y * BOUNDINGRECT.size.y, TOP, BOT)
	#	if mover.velocity.y > 0: mover.velocity.y = 0
		_arcade.set_room_instance(new_room)
