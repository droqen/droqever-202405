extends MarginContainer

var message : String
var message_visible : String
var messind : int = 0
var messind_delay : int = 0
var messagelen : int = 0

func _ready():
	add_to_group("TEXTWIN")
	for spellmen in get_tree().get_nodes_in_group("SPELLMEN"):
		spellmen.connect("spoke", self, "printhistory")

func printhistory(message):
	var h = $v.rect_size.y
	var label_old : Label = $bank.spawn("LabelOld", $v/vHistory)
	label_old.visible_characters = -1#$v/Label.visible_characters
	label_old.text = message
	label_old.update()
	keep_history_maxheight(h + label_old.rect_size.y)
func printmessage(message):
	if $v/Label.text != message:
		if $v/Label.text:
			printhistory($v/Label.text)
		$v/Label.visible_characters = 0
		$v/Label.text = message
		self.message = message
		self.message_visible = message.replace(' ','').replace('\n','')
		messind = 0
		messagelen = len(message_visible)

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
