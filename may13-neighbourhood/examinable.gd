tool

extends Node2D

export (String, MULTILINE) var examination_message = "Hello World"
export (bool) var hidden_indicator = false

func _ready():
	if not Engine.editor_hint and has_node("Label"):
		$Label.queue_free()

func _physics_process(_delta):
	if Engine.editor_hint and has_node("Label") and $Label.text != examination_message:
		$Label.text = examination_message
