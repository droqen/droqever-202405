extends Node
class_name PinController

export var droqever_bridged : bool = true
var droqever_input_locked : bool = false
var droqever_input_timer : float = 0.0
onready var _jscb_get_droqever_input_changed = JavaScript.create_callback(
	self, "_get_droqever_input_changed")

var pin_droqever = PinInputSource.new()
var pin_keyboard = PinInputSource.new()
var pin_gamepad = PinInputSource.new()
var pins = [pin_droqever, pin_keyboard, pin_gamepad]

const DROQEVER_TOUCH_DEFAULT_DEADZONE = 0.25
const GAMEPAD_DEFAULT_DEADZONE = 0.1

var stick : PinStick = PinStick.new()
var a : PinButton = PinButton.new()

func _ready():
	add_to_group("pincontroller")
	pin_droqever.stick.deadzone = DROQEVER_TOUCH_DEFAULT_DEADZONE
	pin_gamepad.stick.deadzone = GAMEPAD_DEFAULT_DEADZONE
	call_deferred("add_child", pin_droqever)
	call_deferred("add_child", pin_keyboard)
	call_deferred("add_child", pin_gamepad)
	if droqever_bridged:
		var Bridge = JavaScript.get_interface("Bridge")
		if Bridge:
			Bridge.report_connection()
			Bridge.setup_joystick_if_mobile(_jscb_get_droqever_input_changed)
			print("gd.  Bridge complete")
		else:
			print("gd.  No bridge (maybe you're not running on web?)")

func _input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_RIGHT, KEY_D: pin_keyboard.stick.pin_dpad(Vector2.RIGHT, event.pressed)
			KEY_UP,    KEY_W: pin_keyboard.stick.pin_dpad(Vector2.UP,    event.pressed)
			KEY_LEFT,  KEY_A: pin_keyboard.stick.pin_dpad(Vector2.LEFT,  event.pressed)
			KEY_DOWN,  KEY_S: pin_keyboard.stick.pin_dpad(Vector2.DOWN,  event.pressed)
			KEY_Z, KEY_X, KEY_SPACE: pin_keyboard.a.pin(event.pressed)
	if event is InputEventJoypadButton:
		match event.button_index:
			# it's not quite right to use 'keyboard' for these buttons
			# but whatever, that's fine
			# *discrete buttons* trump floopy floaty sticks
			12: pin_keyboard.stick.pin_dpad(Vector2.UP,    event.pressed)
			13: pin_keyboard.stick.pin_dpad(Vector2.DOWN,  event.pressed)
			14: pin_keyboard.stick.pin_dpad(Vector2.LEFT,  event.pressed)
			15: pin_keyboard.stick.pin_dpad(Vector2.RIGHT, event.pressed)
			# face buttons
			0, 1, 2, 3: pin_gamepad.a.pin(event.pressed)
	if event is InputEventJoypadMotion:
		match event.axis:
			0: pin_gamepad.stick.pin_axis(Vector2.RIGHT,  event.axis_value)
			1: pin_gamepad.stick.pin_axis(Vector2.UP,     event.axis_value)

func _get_droqever_input_changed(args):
	pin_droqever.stick.pin(Vector2(args[0], args[1]))
	pin_droqever.a.pin(args[2])

func _physics_process(_delta):
	# stick
	for pin in pins:
		if pin.stick.get_smooth_vector():
			stick = pin.stick
			break
	# "a" button
	for pin in pins:
		if pin.a.held:
			a = pin.a
			break
