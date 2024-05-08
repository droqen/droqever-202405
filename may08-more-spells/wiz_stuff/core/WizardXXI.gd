extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$roomman.connect("room_changed", self, "_on_roomman_room_changed")
	_on_roomman_room_changed($roomman.room) # do it
	$wiz.connect("enter_hover", self, "_on_wiz_enter_hover")
	$wiz.connect("leave_hover", self, "_on_wiz_leave_hover")
func _on_roomman_room_changed(room):
	for child in $magicfx.get_children():
		child.queue_free() # delete all children
	$spellman.maze = room.get_maze()
func _on_wiz_enter_hover(exam_zone : ExamZone):
	if $wiz.position.y < 90:
		$textbox_ctr.display_text(exam_zone.get_display_text(), 2)
		$textbox_ctr.connect_displayer(exam_zone)
	else:
		$textbox_ctr.display_text(exam_zone.get_display_text(), 0)
		$textbox_ctr.connect_displayer(exam_zone)
func _on_wiz_leave_hover():
	$textbox_ctr.hide_text()
