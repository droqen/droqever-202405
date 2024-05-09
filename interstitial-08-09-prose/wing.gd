extends NavdiMovingGuy

enum { IDLE=151221, MOVING, }
onready var movst = TinyState.new(IDLE,self,"mut_movst")
func mut_movst(_a,b):
	match b:
		IDLE: spr.setup([34,35,35],20)
		MOVING: spr.setup([35,34,34,35,],5)
func _physics_process(_delta):
	var stick = pin.pc.stick.get_dpad_smoothed_vector()
	if stick.x:
		spr.flip_h = stick.x < 0
	if stick:
		movst.goto(MOVING)
	else:
		movst.goto(IDLE)
	accel_velocity(stick.x * 0.5, stick.y * 0.5, 0.1, 0.1)
	process_slidey_move()
