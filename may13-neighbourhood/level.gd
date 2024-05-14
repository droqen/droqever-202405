tool
extends Node2D

func _enter_tree():
	if filename:
		name = filename.rsplit('/',true,1)[1].split('.',true,1)[0]
	else:
		name = 'level (?)'
	if Engine.editor_hint:
		if get_parent() is Viewport:
			$maze/FlagEditor.show()
		else:
			$maze/FlagEditor.hide()
