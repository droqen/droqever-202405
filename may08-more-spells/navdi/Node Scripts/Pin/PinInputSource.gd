extends Node
class_name PinInputSource

#var active : bool = false
#export var activity_timeout : int = 60
#var since_last_activity : int = 0

var stick : PinStick = PinStick.new()
var a : PinButton = PinButton.new()

#func register_activity(stick : Vector2, a : bool):
#	active = true
#	since_last_activity = 0
func _physics_process(_delta):
#	if active:
#		since_last_activity += 1
#		if since_last_activity >= activity_timeout:
##			for inp in [stick,a]:
##				inp.clr() # no need to clear
#			active = false
	stick.call_deferred("end_frame")
	a.call_deferred("end_frame")
