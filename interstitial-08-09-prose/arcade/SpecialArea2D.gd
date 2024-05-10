tool
extends Area2D
class_name SpecialArea2D
export (String, MULTILINE) var base_description : String
const DYNAMIC_FONT = preload("special_area_font.tres")

func _enter_tree():
	if Engine.editor_hint:
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
		set_collision_layer_bit(13-1, true)
		# layer 13 due to length of 'SPECIALAREA2D'
		if not has_node('shape'):
			var cs = CollisionShape2D.new()
			cs.name = 'shape'
			add_child(cs)
			cs.owner = owner if owner else self
			cs.shape = RectangleShape2D.new()
		if not has_node('label'):
			var no = Label.new()
			no.name = 'label'
			no.add_font_override('font', DYNAMIC_FONT)
			no.add_color_override('font_color', Color.black)
			no.rect_min_size.x = 100
			no.autowrap = true
			add_child(no)
			no.owner = owner if owner else self
		property_list_changed_notify()
	else:
		if has_node('label'):
			$label.queue_free()

func _physics_process(_delta):
	if Engine.editor_hint:
		if has_node('label'):
			$label.text = base_description

func get_intensity() -> int:
	if has_node('shape'):
		var s = $shape.shape
		if s is RectangleShape2D:
			return int(
				9999
				- 10 * min(s.extents.x, s.extents.y)
				-  1 * max(s.extents.x, s.extents.y)
			)
		else:
			push_error("SpecialArea2D.gd cant calculate intensity of nonrect shape")
			return 100
	else:
		return 0

func get_look():
	return base_description
