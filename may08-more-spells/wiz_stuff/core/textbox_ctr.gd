extends Node2D

onready var textbox = $textbox
onready var textbox_mtc = $textbox/m/MarchingTextContainer
var displayer = null
var displayed_text = ""

func _ready():
	hide_text()

func connect_displayer(text_displayer):
	displayer = text_displayer

func display_text(text,anchorid=-1):
	show()
	if anchorid >= 0:
		var p1 = textbox.get_parent()
		var p2 = get_child(anchorid)
		print(p2)
		if p1 != p2:
			if p1: p1.remove_child(textbox)
			if p2: p2.add_child(textbox)
			textbox.position = Vector2.ZERO
	textbox_mtc.setup(text)
	displayed_text = text

func hide_text():
	hide()
	displayer = null
	displayed_text = ""
	textbox_mtc.pause()

func _physics_process(_delta):
	if displayer:
		var dt2 = displayer.get_display_text()
		if displayed_text != dt2:
			display_text(dt2)
