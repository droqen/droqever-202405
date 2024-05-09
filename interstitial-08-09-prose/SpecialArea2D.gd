tool
extends Area2D
class_name SpecialArea2D
export (String, MULTILINE) var base_description : String
const DYNAMIC_FONT = preload("res://level_tools/special_area_font.tres")

func _ready():
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

func get_volume() -> float:
	if has_node('shape'):
		var s = $shape.shape
		if s is RectangleShape2D:
			return s.extents.x * s.extents.y * 4.0
		else:
			push_error("SpecialArea2D.gd cant calculate volume of nonrect shape")
			return 100.0
	else:
		return 0.0

func override_look():
	return base_description
