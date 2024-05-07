extends NavdiMovingGuy

enum {
	IDLE=54, WALK, AIR, PREMEDITATE, MEDITATE, TURN,
	DUCKBUF, TURNBUF, WINGSBUF,
	
	HIDDEN, TYPING, CASTING,
	CASTINGBUF, BKSPBUF,
}
onready var movst = TinyState.new(IDLE, self, "_on_mvst_chg")
var medi : float = 0.0

onready var spellst = TinyState.new(HIDDEN, self, "_on_spellst_chg")
func _on_spellst_chg(_then,now):
	match now:
		HIDDEN:
			textinput = ""
			$type/z/input.text = ""
			$type/z.hide()
		TYPING:
			textinput = ""
			_on_textinput_changed()
		CASTING:
			bufs.setmin(CASTINGBUF, 40)

func get_gravity():
	var g = 0.05
	if bufs.has(WINGSBUF): g = 0.025
	return g

var textinput_regex : RegEx
onready var textinput_labelnode : Label = $type/z/input
var textinput : String = "debug"
var textinputlen : int = 0
var textblinkani : int = 0
const TEXTINP_MAXLEN : int = 10
const TBA_OFF : int = 30
const TBA_MOD : int = 50

func _on_mvst_chg(then,now):
	match then:
		PREMEDITATE:
			bufs.clr(DUCKBUF)
		MEDITATE:
			bufs.clr(DUCKBUF)
			if spellst.id == TYPING: spellst.goto(HIDDEN)
	match now:
		IDLE:
			spr.setup([10,10,10,10,10,10,10,15,16,10,10,10,10,10,10,10,], 7)
		WALK:
			spr.setup([10,11] if spr.frame==11 else [11,10],8)
		AIR:
			spr.setup([11])
		TURN:
			spr.setup([17])
		PREMEDITATE:
			spr.setup([13,13,14,12,13,14,12,], 7)
		MEDITATE:
			spellst.goto(TYPING)
func _ready():
	textinput_regex = RegEx.new()
	textinput_regex.compile("^[A-Za-z0-9 ]$")
	bufs.defons([
		[DUCKBUF,4],[TURNBUF,2],
	])
func _physics_process(_delta):
	var stick = Vector2.ZERO
	var a = PinButton.new()
	if pin.pc:
		stick = pin.pc.stick.get_dpad_smoothed_vector()
		for button in [pin.pc.a,pin.pc.stick.up]:
			for prop in ['pressed', 'held', 'released']:
				if button.get(prop): a.set(prop,true)
	
	bufs.process_bufs()
	if bufs.has(FLORBUF) and stick.y > 0.5: bufs.on(DUCKBUF)
	
	match movst.id:
		PREMEDITATE:
			accel_velocity(0.0, 2.0, 0.1,
				get_gravity())
			bufs.on(DUCKBUF)
			if medi < 0.5:
				medi = move_toward(lerp(medi, 0.5, 0.2), 1.0, 0.001)
				if stick.y < 0.5:
					movst.goto(IDLE)
				$type/z/input.text = ""
			else:
				movst.goto(MEDITATE)
				_on_textinput_changed() # update
			
			if stick.x and stick.y < 0.5:
				movst.goto(IDLE)
		MEDITATE:
			accel_velocity(0.0, 2.0, 0.1,
				get_gravity())
			medi = move_toward(lerp(medi, 1.0, 0.2), 1.0, 0.002)
		_:
			var fastfallmult = 1.0
			if velocity.y < 0 and not a.held: fastfallmult = 2.4
			accel_velocity(stick.x * 1.0, 2.0, 0.1,
				get_gravity() * fastfallmult)
			medi = move_toward(lerp(medi, 0.0, 0.2), 0.0, 0.01)
			
			if stick.x and spr.flip_h != (stick.x < 0):
				bufs.on(TURNBUF)
				movst.goto(TURN)
				spr.flip_h = stick.x < 0
			if a.pressed: bufs.on(JUMPBUF)
	
	match spellst.id:
		TYPING:
			if bufs.has(BKSPBUF):
				textinput_labelnode.visible_characters = textinputlen + 1
				if bufs.read(BKSPBUF) % 10 > 5:
					$type/z.hide()
				else:
					$type/z.show()
			else:
				$type/z.show()
				textblinkani += 1
				if textblinkani == TBA_OFF:
					textinput_labelnode.visible_characters = textinputlen
				elif textblinkani >= TBA_MOD:
					textblinkani = 0
					textinput_labelnode.visible_characters = textinputlen + 1
		CASTING:
			textinput_labelnode.visible_characters = textinputlen + 1
			if bufs.has(CASTINGBUF):
				if bufs.read(CASTINGBUF) % 10 > 5:
					$type/z.hide()
				else:
					$type/z.show()
			else:
				spellst.goto(HIDDEN)
	
	if medi > 0.0:
		$study/left.position.x = lerp(-10 - position.x, -3, medi)
		$study/right.position.x = lerp(210 - position.x, 3, medi)
		$study/left.show()
		$study/right.show()
	else:
		$study/left.hide()
		$study/right.hide()
	
	if bufs.try_consume([JUMPBUF,FLORBUF]):
		velocity.y = -1.5
	process_slidey_move()
	if bufs.has(TURNBUF):
		movst.goto(TURN)
	elif bufs.has(FLORBUF):
		if movst.id == MEDITATE:
			pass # stay in this state
		elif bufs.has(DUCKBUF):
			movst.goto(PREMEDITATE)
		elif stick.x:
			movst.goto(WALK)
		else:
			movst.goto(IDLE)
	else:
		movst.goto(AIR)
func _input(event):
	if event is InputEventKey and event.pressed:
		if spellst.id == TYPING:
			match event.scancode:
				KEY_BACKSPACE:
					if textinputlen > 0:
						textinput = textinput.substr(0, textinputlen - 1)
						_on_textinput_changed()
					elif bufs.has(BKSPBUF):
						print("cancel blank meditation")
						spellst.goto(CASTING)
						movst.goto(IDLE)
					else:
						bufs.setmin(BKSPBUF, 60)
				KEY_ENTER:
					print("submit meditation")
					spellst.goto(CASTING)
					movst.goto(IDLE)
					get_tree().call_group("SPELLMEN", "castspell", textinput, self) # cast!
#				KEY_SPACE:
#					if not textinput.ends_with(' '):
#						textinput_add(' ')
#						_on_textinput_changed()
				_:
					var c = event.as_text()
					if c.begins_with("Shift+"): c.erase(0,6)
					if textinput_regex.search(c):
						textinput_add(c)
						_on_textinput_changed()
					else:
						pass #prints("no typed",c)

func textinput_add(c):
	if textinputlen < TEXTINP_MAXLEN:
		textinput += c
		_on_textinput_changed()

func _on_textinput_changed():
	bufs.clr(BKSPBUF)
	textinputlen = len(textinput)
	textblinkani = 0
	if textinputlen >= TEXTINP_MAXLEN:
		textinput_labelnode.text = textinput + "."
	else:
		textinput_labelnode.text = textinput + "_"
	textinput_labelnode.visible_characters = textinputlen + 1
	var inplab = $type/z/input
	$type/z.show()
	inplab.rect_size.x = 0
	yield(get_tree(),"idle_frame")
	
	var x = position.x + 1 - ceil(inplab.rect_size.x/2)
	var y = position.y - 10
	x = clamp(x, 1, 180 - inplab.rect_size.x)
	inplab.rect_position = Vector2(x, y)
	# find my on-screen position and borders, keep me in the middle

func enable_wings():
	bufs.setmin(WINGSBUF, 1000)
