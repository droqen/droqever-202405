extends NavdiMovingGuy

enum { RESTING=151221, IDLE, WALK, AIR }
onready var movst = TinyState.new(RESTING,self,"mut_movst")
func mut_movst(_a,b):
	match b:
		RESTING: spr.setup([26,26,25],30)
		IDLE: spr.setup([15])
		WALK:
			match spr.frame:
				18: spr.setup([19,16,17,18],11)
				_ : spr.setup([16,17,18,19],11)
		AIR: spr.setup([18])
func _physics_process(_delta):
	bufs.process_bufs()
	
	var stick = pin.pc.stick.get_dpad_smoothed_vector()
	var a = PinButton.new().append(pin.pc.a).append(pin.pc.stick.up)
	
	if movst.id == RESTING:
		stick *= 0
		velocity.y = 1
	
	if a.pressed:
		bufs.on(JUMPBUF)
	if bufs.try_consume([JUMPBUF,FLORBUF]):
		velocity.y = -1
	
	accel_velocity(stick.x * 0.5, 1.0, 0.1, 0.04)
	process_slidey_move()
	
	if movst.id == RESTING and velocity.y >= 0:
		pass
	elif bufs.has(FLORBUF):
		if stick.x and velocity.x:
			movst.goto(WALK)
		else:
			movst.goto(IDLE)
	else:
		movst.goto(AIR)
	if stick.x:
		spr.flip_h = stick.x < 0

	ArcadeScreenUtils.keep_on_screen(self)
