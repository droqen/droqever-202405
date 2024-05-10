tool
extends BaseInteractionArea
class_name RoomPortal

export var direction : Vector2
export (PackedScene) var drop_target_room setget _set_targetroom
export (String, FILE, "*.tscn") var target_room : String
export var target_edgewarp : bool = true
export var target_samespot : bool = false

var _preloader = null
var _preloaded_target_room = null

func _ready():
	if not Engine.editor_hint:
		if target_room:
			_preloader = ResourceLoader.load_interactive(target_room)
			if _preloader == null:
				prints("RoomPortal starting preloader for room '",target_room,"' failed")

func override_generate_rect_extents(extents : Vector2 = Vector2.ZERO) -> Vector2:
	self.direction = ArcadeScreenUtils.get_off_edge_direction(position)
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
	if target_edgewarp and direction == Vector2.ZERO:
		return "target_edgewarp requires a nonzero Direction (cardinal only plz)"
	elif target_room == "":
		return "Portal has no Target Room, it will not function without one"
	else:
		return ""
func _physics_process(_delta):
	if not Engine.editor_hint:
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
				var wiz_off : Vector2 = ArcadeScreenUtils.get_off_edge_direction(wiz.position)
				if direction.x == 0: wiz_off.x *= 0
				if direction.y == 0: wiz_off.y *= 0
				if wiz_off == direction:
					if target_room:
						ArcadeScreenUtils.launch_edge_room(
							_preloaded_target_room if _preloaded_target_room else target_room,
							direction,
							wiz
						)
					else:
						wiz.position -= direction * 10
			elif target_samespot:
				ArcadeScreenUtils.launch_warp_room(
					_preloaded_target_room if _preloaded_target_room else target_room
				)
