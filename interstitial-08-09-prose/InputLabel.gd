extends Label

enum {
	NONE = 12412444,
	SUBMITBUF,
}
onready var bufs : Bufs = Bufs.new([[SUBMITBUF,40]])
var input_text : String = ""
var input_text_len : int
var input_text_spacecount : int
var blinker : int = 0
const INPUT_TEXT_MAXLEN : int = 10

var valid_inputs_regex : RegEx = RegEx.new()

func _ready():
	on_text_updated()
	valid_inputs_regex.compile("[A-Za-z]")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ENTER:
			if not event.echo:
				submit()
		elif event.scancode == KEY_BACKSPACE:
			input_text = input_text.substr(0, input_text_len - 1)
			on_text_updated()
		elif input_text_len < INPUT_TEXT_MAXLEN + input_text_spacecount:
			var t = event.as_text().replace('Shift+','')
			if len(t) == 1 and valid_inputs_regex.search(t):
				input_text += t
				on_text_updated()
#			elif event.scancode == KEY_SPACE:
#				if input_text_len > 0 and input_text[input_text_len-1] != ' ':
#					input_text += ' '
#					on_text_updated()

func _physics_process(_delta):
	bufs.process_bufs()
	if bufs.has(SUBMITBUF):
		visible_characters = 0 if bufs.read(SUBMITBUF) % 6 > 3 else -1
	elif bufs.wasjustcleared(SUBMITBUF):
		input_text = ''
		on_text_updated()
	else:
		blinker += 1
		if blinker == 60:
			visible_characters = input_text_len
		if blinker >= 80:
			blinker = 0
			visible_characters = input_text_len + 1

func on_text_updated():
	bufs.clr(SUBMITBUF)
	input_text_len = len(input_text)
	input_text_spacecount = input_text.count(' ')
	text = input_text.to_upper() + (
		"_" if input_text_len < INPUT_TEXT_MAXLEN + input_text_spacecount else "."
	)
	visible_characters = input_text_len + 1
	blinker = 0

func submit():
	if input_text:
		get_tree().call_group("SPELLMEN", "castspell", input_text)
		input_text = ''
		bufs.on(SUBMITBUF) # SUBMITTED.
	else:
		on_text_updated()
