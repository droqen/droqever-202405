tool
extends Node2D

export var size : Vector2 = Vector2(100,100)

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(-Vector2.ONE*1.0, size+Vector2.ONE*2.0), Color(.5,.5,.5,.25), false, 2.0)
		draw_rect(Rect2(-Vector2.ONE*0.1, size+Vector2.ONE*0.2), Color.magenta, false)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
