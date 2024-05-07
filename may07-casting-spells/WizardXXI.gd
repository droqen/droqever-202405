extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$roomman.connect("room_changed", self, "_on_roomman_room_changed")
func _on_roomman_room_changed():
	for child in $magicfx.get_children():
		child.queue_free() # delete all children
