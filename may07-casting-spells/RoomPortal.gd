tool
extends Area2D
class_name RoomPortal
export var newrectplease : bool setget _set_newrectplz
export var direction : Vector2
export (PackedScene) var drop_target_room setget _set_targetroom
export (String, FILE, "*.tscn") var target_room : String
export var target_edgewarp : bool = true

var _preloader = null
var _preloaded_target_room = null

func _ready():
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(2, true) # detecting wiz (2=3)
	# i have no layer
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(3, false)
	
	if not Engine.editor_hint:
		if target_room:
			_preloader = ResourceLoader.load_interactive(target_room)
			if _preloader == null:
				prints("RoomPortal starting preloader for room '",target_room,"' failed")
	
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
		direction = Vector2.ZERO
		if position.x < 0:
			direction.x = -1
		if position.y < 0:
			direction.y = -1
		if position.x > 180:
			direction.x = 1
		if position.y > 180:
			direction.y = 1
		if (
			(direction.x and not direction.y and extents.x > extents.y)
			or
			(direction.y and not direction.x and extents.y > extents.x)
		):
			extents = Vector2(extents.y, extents.x)
		shape_node.shape.extents = extents
		property_list_changed_notify()
		shape_node.property_list_changed_notify()
		shape_node.shape.property_list_changed_notify()
func _set_targetroom(v : PackedScene):
	if v:
		print(v.resource_path)
		target_room = v.resource_path
		property_list_changed_notify()
func _get_configuration_warning():
	if direction == Vector2.ZERO:
		return "Portal has no Direction set, Direction is important"
	elif target_room == "":
		return "Portal has no Target Room, it will not function without one"
	else:
		return ""
func _physics_process(_delta):
	if _preloader:
		var err = _preloader.poll()
		match err:
			ERR_FILE_EOF: # done
				_preloaded_target_room = _preloader.get_resource().instance()
				_preloader = null
			OK:
				pass
			_:
				prints("RoomPortal preloading failed ERR #", err)
				_preloader = null
		
	for wiz in get_overlapping_bodies():
		if (
			(direction.x == 0 or sign(wiz.velocity.x) == sign(direction.x))
			and
			(direction.y == 0 or sign(wiz.velocity.y) == sign(direction.y))
		):
			if target_edgewarp:
				if direction.x < 0 and wiz.position.x > 0: break
				if direction.x > 0 and wiz.position.x < 180: break
				if direction.y < 0 and wiz.position.y > 0: break
				if direction.y > 0 and wiz.position.y < 180: break
				print(target_room)
				if target_room:
					get_tree().call_group("ROOMMEN", "launch_edge_room",
						_preloaded_target_room if _preloaded_target_room else target_room,
						direction,
						wiz
					)
				else:
					wiz.position -= direction * 10
		# hopefully there is only 1 of these.
