tool
extends Area2D
class_name BaseWizardInteractionArea

signal wiz_entered(wiz)
signal wiz_exited(wiz)
var wiz = null

export var newrectplease : bool setget _set_newrectplz

func _set_newrectplz(v):
	if v:
		var shape_node : CollisionShape2D = get_node_or_null("CollisionShape2D")
		if not shape_node:
			shape_node = CollisionShape2D.new()
			add_child(shape_node)
			shape_node.owner = owner if owner else self
		var extents = Vector2(10 + randi() % 100, 10) # random extents
		if shape_node.shape: extents = shape_node.shape.extents
		shape_node.shape = RectangleShape2D.new()
		shape_node.shape.extents = override_generate_rect_extents()
		property_list_changed_notify()
		shape_node.property_list_changed_notify()
		shape_node.shape.property_list_changed_notify()

func override_generate_rect_extents(preexisting_extents : Vector2 = Vector2.ZERO) -> Vector2:
	return Vector2(10,10)

func _ready():
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(2, true) # detecting wiz (2=3)
	# i have no layer
	set_collision_layer_bit(0, false)

func _physics_process(_delta):
	var wizzes = get_overlapping_bodies()
	if wizzes:
		for newwiz in wizzes:
			if wiz != newwiz:
				wiz = newwiz
				emit_signal("wiz_entered", wiz)
	else:
		if wiz:
			emit_signal("wiz_exited", wiz)
			wiz = null
