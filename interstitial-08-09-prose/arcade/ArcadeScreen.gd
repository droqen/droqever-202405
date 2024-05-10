tool
extends Node2D

export var size : Vector2 = Vector2(100,100)

var room #: ArcadeRoom

func _ready():
	ArcadeScreenUtils.setup(self)
	if $RoomContainer.get_child_count() > 0:
		room = $RoomContainer.get_child(0)

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(-Vector2.ONE*1.0, size+Vector2.ONE*2.0), Color(.5,.5,.5,.25), false, 2.0)
		draw_rect(Rect2(-Vector2.ONE*0.1, size+Vector2.ONE*0.2), Color.magenta, false)

func clear_rooms():
	for child in $RoomContainer.get_children():
		child.queue_free()
func set_room_instance(new_room : Node2D):
	clear_rooms()
	$RoomContainer.add_child(new_room)
	new_room.owner = owner if owner else self
	self.room = new_room
#	emit_signal("room_changed", self.room)
