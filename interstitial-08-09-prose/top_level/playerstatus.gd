extends Node

signal event_added(msg)
signal cast_changed(cast)
signal look_changed(look)
signal look_left()

enum {
	LOOKBUF,
}

onready var bufs : Bufs = Bufs.new([[LOOKBUF,4]])

# misnomer, not immediate mode at all
func imm_cast(_message : String):
	cast_string = _message # that's it
	emit_signal('cast_changed', cast_string)
var cast_string : String = ''

# as in "append event"
func app_event(_message : String):
	emit_signal('event_added', _message)

# immediate-ish mode 'look', shows a description
func imm_look(_message : String, _intensity : int):
	if _intensity == look_intensity and _message == look_string:
		bufs.on(LOOKBUF)
	elif _intensity > look_intensity or bufs.read(LOOKBUF) <= 1:
		bufs.on(LOOKBUF)
		look_string = _message
		look_intensity = _intensity
		emit_signal('look_changed', look_string)
var look_string : String = ''
var look_intensity : int = 0

func _physics_process(_delta):
	bufs.process_bufs()
	if bufs.wasjustcleared(LOOKBUF):
		look_string = ''
		look_intensity = 0
		emit_signal('look_left')
