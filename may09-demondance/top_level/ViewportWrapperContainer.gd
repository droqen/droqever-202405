tool
extends Container
class_name ViewportWrapperContainer

signal rect_and_scale_changed(rect, scale)

export var autosetup : bool setget _do_autosetup
func _do_autosetup(v): if v:
	if not has_node("ViewportContainer"):
		var vc = ViewportContainer.new()
		add_child(vc)
		vc.owner = owner if owner else self
	if not has_node("ViewportContainer/Viewport"):
		var vp = Viewport.new()
		$ViewportContainer.add_child(vp)
		vp.owner = owner if owner else self

func _get_configuration_warning():
	if has_node("ViewportContainer/Viewport"):
		return ""
	else:
		return ("ViewportWrapperContainer is missing ViewportContainer/Viewport;"
			+"\nclick autosetup to set up the correct hierarchy")

func _ready():
	if not Engine.editor_hint:
		connect("sort_children", self, "fix_size")

func _notification(what: int) -> void:
	if Engine.editor_hint:
		match what:
			NOTIFICATION_SORT_CHILDREN:
				fix_size()

func fix_size():
	var base_size : Vector2 = Vector2(100, 100)
	$ViewportContainer.stretch = true
	if $ViewportContainer/Viewport.get_child_count() and $ViewportContainer/Viewport.get_child(0).get('size'):
		base_size = $ViewportContainer/Viewport.get_child(0).size
	$ViewportContainer/Viewport.size = base_size
	var pixelscale : int = int(max(1, floor(min(rect_size.x/base_size.x, rect_size.y/base_size.y))))
	$ViewportContainer.stretch_shrink = pixelscale
	var scaled_size = base_size * pixelscale
	var child_rect = Rect2((rect_size - scaled_size) * 0.5, scaled_size)
	fit_child_in_rect(get_child(0), child_rect)
	emit_signal("rect_and_scale_changed", child_rect, pixelscale)
