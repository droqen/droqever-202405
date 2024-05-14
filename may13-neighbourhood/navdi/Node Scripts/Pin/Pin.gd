extends Node
class_name Pin

var pc : PinController

func _ready():
	for _pc in get_tree().get_nodes_in_group("pincontroller"):
		pc = _pc
