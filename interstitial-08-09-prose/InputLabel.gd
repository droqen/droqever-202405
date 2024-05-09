extends Label

var input_text : String = ""
var input_text_len : int
var blinker : int = 0
const INPUT_TEXT_MAXLEN : int = 10

func _ready():
	on_text_updated()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_BACKSPACE:
			input_text = input_text.substr(0, input_text_len - 1)
			on_text_updated()
		elif input_text_len < INPUT_TEXT_MAXLEN:
			var t = event.as_text()
			if t.is_valid_identifier() and len(t) == 1:
				input_text += t
				on_text_updated()

func _physics_process(_delta):
	blinker += 1
	if blinker == 30:
		visible_characters = input_text_len
	if blinker >= 50:
		blinker = 0
		visible_characters = input_text_len + 1

func on_text_updated():
	input_text_len = len(input_text)
	if input_text_len < INPUT_TEXT_MAXLEN:
		text = input_text + "_"
	else:
		text = input_text + "."
	visible_characters = input_text_len + 1
	blinker = 0
