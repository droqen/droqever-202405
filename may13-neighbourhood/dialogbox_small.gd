extends Node2D

signal exited

enum {DISPLAYTOP, DISPLAYBOTTOM, DISPLAY, NODISPLAY}

onready var mtc = $m/m/MarchingText

var candismiss = false
var blinker : int = 0

onready var indicator_y = $indicator.position.y

onready var dbst = TinyState.new(NODISPLAY, self, "_mut_dbst")
func _mut_dbst(_a,b):
	match b:
		DISPLAYTOP:
			position.y = 0
			dbst.goto(DISPLAY)
		DISPLAYBOTTOM:
			position.y = 140
			dbst.goto(DISPLAY)
		DISPLAY:
			show()
			candismiss = false
		NODISPLAY:
			hide()
			emit_signal("exited")
func _physics_process(_delta):
	if dbst.id == DISPLAY:
		if mtc.is_done():
			$indicator.show()
			blinker = posmod(blinker+1,45)
			$indicator.position.y = indicator_y + (1 if blinker>15 else 0)
		else:
			$indicator.hide()
			blinker = 0
		
		if not $Pin.pc.a.held and not $Pin.pc.stick.down.held:
			candismiss = true
		
		if candismiss and ($Pin.pc.a.pressed or $Pin.pc.stick.down.pressed):
			if mtc.is_done():
				dbst.goto(NODISPLAY) # dismiss
			else:
				mtc.set_position_end() # force done.
func set_message(message):
	$m/m/MarchingText.setup(message)
