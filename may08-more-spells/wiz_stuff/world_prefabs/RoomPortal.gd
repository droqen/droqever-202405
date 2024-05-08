tool
extends BaseWizardInteractionArea
class_name RoomPortal

export var direction : Vector2
export (PackedScene) var drop_target_room setget _set_targetroom
export (String, FILE, "*.tscn") var target_room : String
export var target_edgewarp : bool = true

var _preloader = null
var _preloaded_target_room = null

func _ready():
	if not Engine.editor_hint:
		if target_room:
			_preloader = ResourceLoader.load_interactive(target_room)
			if _preloader == null:
				prints("RoomPortal starting preloader for room '",target_room,"' failed")

func override_generate_rect_extents(extents : Vector2 = Vector2.ZERO) -> Vector2:
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
	return extents

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
		
	
	if wiz and (
		(direction.x == 0 or sign(wiz.velocity.x) == sign(direction.x))
		and
		(direction.y == 0 or sign(wiz.velocity.y) == sign(direction.y))
	):
		if target_edgewarp:
			var wiz_inbounds = false
			if direction.x < 0 and wiz.position.x > 0: wiz_inbounds = true
			if direction.x > 0 and wiz.position.x < 180: wiz_inbounds = true
			if direction.y < 0 and wiz.position.y > 0: wiz_inbounds = true
			if direction.y > 0 and wiz.position.y < 180: wiz_inbounds = true
			if not wiz_inbounds:
				if target_room:
					get_tree().call_group("ROOMMEN", "launch_edge_room",
						_preloaded_target_room if _preloaded_target_room else target_room,
						direction,
						wiz
					)
				else:
					wiz.position -= direction * 10
