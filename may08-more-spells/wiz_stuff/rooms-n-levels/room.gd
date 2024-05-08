tool
extends Node2D

func _enter_tree():
	var newname = filename.rsplit('/',true,1)[1].split('.',true,1)[0]
	if name != newname:
		name = newname
		property_list_changed_notify()
	
	var is_root_or_play_mode = not Engine.editor_hint or get_parent() is Viewport
	prints(name,is_root_or_play_mode)
	set_visibility_if_exists("maze/FlagEditor", is_root_or_play_mode)
	set_visibility_if_exists("labels", is_root_or_play_mode)
	
	if not Engine.editor_hint:
		if has_node("labels"):
			$labels.position = Vector2.ZERO
			if has_node("labels/test_color_rect"):
				$labels/test_color_rect.hide() # delete it
				$labels/test_color_rect.queue_free() # delete it

func set_visibility_if_exists(path, visibility):
	if has_node(path):
		get_node(path).call('show' if visibility else 'hide')
func get_maze() -> NavdiFlagMazeMaster:
	return $maze as NavdiFlagMazeMaster
