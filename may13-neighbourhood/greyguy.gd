extends NavdiMovingGuy

signal read

enum {
	STAND=129, WALK, AIR, CHECK, READING, ASLEEP, ASLEEP_WAKING,
	CHECKBUF, NOINPBUF, READINGBUF,
}
onready var ggst = TinyState.new(STAND, self, "_mut_ggst")
func _mut_ggst(a,b):
	match a:
		READING:
			bufs.clr(JUMPBUF) # clear jump input
			bufs.on(NOINPBUF)
			bufs.clr(CHECKBUF)
			if b == AIR:
				velocity.y = -0.50
				bufs.clr(FLORBUF)
	match b:
		STAND: spr.setup([10])
		AIR:
			spr.setup([17])
		WALK:
			if spr.frame == 10:
				spr.setup([11,11,10],5)
			else:
				spr.setup([10,11,11],5)
		CHECK:
			spr.setup([16,15,15,15,15,15,15,15,],5)
			bufs.on(CHECKBUF)
			velocity *= 0
			if $examiner.target:
				emit_signal("read", $examiner.target)
		READING:
			spr.setup([15])
		ASLEEP:
			spr.setup([20])
		ASLEEP_WAKING:
			spr.setup([21,20,21,21,20,20,21,20,21,20,20,20,], 8)

func _ready():
	bufs.defons([[CHECKBUF,20],[NOINPBUF,3],[READINGBUF,3]])
	reset()

func reset():
	velocity *= 0
	spr.flip_h = position.x > 100
	ggst.goto(ASLEEP)
	bufs.on(NOINPBUF)

func _physics_process(_delta):
	bufs.process_bufs()
	var stick : Vector2 = pin.pc.stick.get_dpad_smoothed_vector()
	var a : PinButton = PinButton.new()
	if pin.pc.a.pressed: a.pressed = true
	if pin.pc.stick.up.pressed: a.pressed = true
	var exampressed : bool = pin.pc.stick.down.pressed
	if bufs.has(NOINPBUF) or ggst.id == READING:
		stick *= 0
		a = PinButton.new()
		exampressed = false
	if ggst.id == ASLEEP or ggst.id == ASLEEP_WAKING:
		exampressed = false
	if a.pressed: bufs.on(JUMPBUF)
	if bufs.has(FLORBUF) and exampressed: ggst.goto(CHECK)
	match ggst.id:
		ASLEEP, ASLEEP_WAKING:
			accel_velocity(0.0, 2.0, 0.1, 0.08)
			if bufs.try_consume([JUMPBUF, FLORBUF]):
				if ggst.id == ASLEEP:
					velocity.y = -0.50
					ggst.goto(ASLEEP_WAKING)
				elif ggst.id == ASLEEP_WAKING:
					velocity.y = -1.00
					ggst.goto(AIR)
		CHECK, READING:
			accel_velocity(0.0, 2.0, 0.1, 0.08)
		_:
			accel_velocity(stick.x, 2.0, 0.1, 0.08)
			if stick.x: spr.flip_h = stick.x < 0
	if bufs.try_consume([JUMPBUF,FLORBUF]): velocity.y = -2.0
	process_slidey_move()
	if ggst.id == ASLEEP or ggst.id == ASLEEP_WAKING:
		pass
	elif bufs.has(FLORBUF):
		if bufs.has(CHECKBUF): ggst.goto(CHECK)
		elif bufs.has(READINGBUF): ggst.goto(READING)
		elif stick.x: ggst.goto(WALK)
		else: ggst.goto(STAND)
	else:
		ggst.goto(AIR)

func proc_reading():
	bufs.on(READINGBUF)
