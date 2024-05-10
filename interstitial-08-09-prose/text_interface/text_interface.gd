extends MarginContainer

var message : String
var message_visible : String
var messind : int = 0
var messind_delay : int = 0
var messagelen : int = 0

onready var LookLabel = $v/LookLb
onready var CastLabel = $v/CastLb
onready var EventLabel = $v/EventLb

func _ready():
	PlayerStatus.connect("look_changed", self, "_look_changed")
	PlayerStatus.connect("look_left", self, "_look_left")
	PlayerStatus.connect("cast_changed", self, "_cast_changed")
	PlayerStatus.connect("event_added", self, "_event_added")
func _look_changed(msg):
	LookLabel.goaltext = msg
func _look_left():
	LookLabel.typst.goto(LookLabel.IDLE)
func _cast_changed(msg):
	CastLabel.goaltext = msg
func _event_added(msg):
	if EventLabel.colourlerp <= 0 or not EventLabel.goaltext:
		EventLabel.goaltext = msg
	else:
		EventLabel.goaltext += ' ' + msg

func keep_history_maxheight(curheight : int):
	prints(curheight, rect_min_size.y)
	while curheight > rect_min_size.y and $v/vHistory.get_child_count():
		var history_entry : Control = $v/vHistory.get_child(0)
		curheight -= history_entry.rect_size.y
		history_entry.hide()
		history_entry.queue_free()

func _physics_process(_delta):
	if messind + 1 < messagelen:
		if messind_delay > 0:
			messind_delay -= 1
		else:
			messind += 1
			$v/Label.visible_characters = messind + 1
			var c = message_visible[messind]
			match c:
				'.': messind_delay = 10
				_:
					pass
