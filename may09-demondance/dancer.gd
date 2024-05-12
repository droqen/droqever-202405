extends NavdiMovingGuy

enum {
	IDLE = 44, WALK, AIR,
	NONE = 0, ONE = 1, TWO = 2,
	KNOCKBACKBUF = 2911,
}
onready var danst = TinyState.new(AIR, self, "muts_dan_ammo", true)
onready var ammost = TinyState.new(TWO, self, "muts_dan_ammo", true) # how much ammo u got?

func muts_dan_ammo(_a,_b):
	match [danst.id,ammost.id]:
		[_, NONE]: spr.setup([50])
		[_, ONE]:  spr.setup([60])
		[_, TWO]:  spr.setup([70])

func _ready():
	muts_dan_ammo(NONE, ammost.id)
	bufs.defons([
		[FLORBUF,4],
	])

func _physics_process(_delta):
	bufs.process_bufs()
	var stick : Vector2
	var a = PinButton.new()
	var b = PinButton.new()
	if pin and pin.pc:
		stick = pin.pc.stick.get_dpad_smoothed_vector()
		a.append(pin.pc.a)
		b.append(pin.pc.b)
	if stick.x: spr.flip_h = stick.x < 0
	var grounded = bufs.has(FLORBUF)
	var xaccel : float = 0.1 if grounded else 0.04
	if bufs.has(KNOCKBACKBUF): xaccel *= 0.25
	var yaccel : float = 0.01
	if not grounded and not a.held: yaccel *= 2
	if a.pressed: bufs.on(JUMPBUF)
	if b.pressed and ammost.id > 0:
		ammost.goto(ammost.id - 1)
		var attack_dir : Vector2 = stick.normalized()
		if attack_dir == Vector2.ZERO: attack_dir = Vector2(-1 if spr.flip_h else 1, 0)
#		velocity -= velocity.project(attack_dir.normalized()) + attack_dir
		velocity.x = -1.25 * sign(attack_dir.x)
		velocity.y = -1.0 * sign(attack_dir.y)
		if velocity.y <= 0: velocity.y -= 0.25
		bufs.setmin(KNOCKBACKBUF,30)
		$bank.spawn("shot",get_parent(),position).setup(attack_dir,spr.flip_h)
	if bufs.try_consume([JUMPBUF,FLORBUF]):
		velocity.y = -1.0
	accel_velocity(stick.x * 1.0, 2.0, xaccel, yaccel)
	process_slidey_move()
	if not grounded and bufs.has(FLORBUF):
		ammost.goto(TWO)
