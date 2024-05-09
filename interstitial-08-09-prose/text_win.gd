extends MarginContainer

export var output_font : DynamicFont
export var input_font : DynamicFont

var message : String
var message_visible : String
var messind : int = 0
var messind_delay : int = 0
var messagelen : int = 0

func _ready():
	connect("sort_children", self, "_adjust_font_size")
func _adjust_font_size():
	output_font.size = int(floor(sqrt(rect_size.x * rect_size.y) * 0.03))/2*2
	input_font.size = int(floor(sqrt(rect_size.x * rect_size.y) * 0.07))/2*2

func printmessage(message):
	$v/Label.visible_characters = 0
	$v/Label.text = message
	self.message = message
	self.message_visible = message.replace(' ','').replace('\n','')
	messind = 0
	messagelen = len(message_visible)

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
