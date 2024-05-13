extends NavdiMovingGuy

enum { STAND=950, RUN, SPLOOSH, SPLOOSH_FROZE_BUF, SPLOOSH_NOREPEAT_BUF, SPLOOSH_INPUT_BUF }
onready var movst = TinyState.new(STAND,self,"mut_mov")
var laststick 
func mut_mov(_a,b):
	match b:
		STAND: spr.setup([90])
		RUN: spr.setup([91,91,90,92,92,90],4)
		SPLOOSH:
			velocity *= 0
			spr.setup([91,92],3)
			bufs.setmin(SPLOOSH_FROZE_BUF, 10)
			bufs.setmin(SPLOOSH_NOREPEAT_BUF, 23)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var stick : Vector2 = pin.pc.stick.get_dpad_smoothed_vector()
	var a : PinButton = pin.pc.a
	bufs.process_bufs()
	if a.pressed: bufs.setmin(SPLOOSH_INPUT_BUF, 6)
	match movst.id:
		SPLOOSH:
			velocity *= 0
			if not bufs.has(SPLOOSH_FROZE_BUF): movst.goto(RUN if stick else STAND)
		_:
			if stick.x: spr.flip_h = stick.x < 0
			movst.goto(RUN if stick else STAND)
			accel_velocity(stick.x,stick.y * (0.5 if stick.x else 1.0),0.5,0.5)
			if bufs.has(SPLOOSH_INPUT_BUF) and not bufs.has(SPLOOSH_NOREPEAT_BUF):
				$bank.spawn("sploosh", get_parent(), position).setup(spr.flip_h, stick.y)
				movst.goto(SPLOOSH)
	process_slidey_move()
	
