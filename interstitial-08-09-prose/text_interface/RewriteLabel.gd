extends Label
class_name RewriteLabel

var goalcolour:float = 0.0
var colourlerp:float = 0.0

export(String,MULTILINE)var goaltext:String
export(int)var done_expiry:int=-1
enum { IDLE, BKSPING, TYPING, DONE,
	TYPE_PAUSE_BUF, DONE_EXPIRY_BUF, }
onready var bufs = Bufs.new([[TYPE_PAUSE_BUF,20]])
onready var typst = TinyState.new(BKSPING, self, "mut_typst")
export(Resource)var palette = preload("res://text_interface/default_rew_palette.tres")
func mut_typst(a,b):
	match a:
		BKSPING:
			if _rew_bksp_count > 1:
				bufs.on(TYPE_PAUSE_BUF)
	match b:
		IDLE:
			goaltext = ''
			_rewt2 = ''
			goalcolour = 0.0
		BKSPING:
			_rew_bksp_count = 0
			if visible_characters < 0:
				visible_characters = len(visify(text))
		TYPING:
			goalcolour = 1.0
			if visible_characters == _rew_pivot:
				text = _rewt2
				visible_characters = _rew_pivot
			else:
				text = _rewt2
		DONE:
			goalcolour = 1.0
			bufs.setmin(DONE_EXPIRY_BUF, done_expiry)

var _rewt2 : String
var _rewt2_vis : String
var _rewt2_vislen : int
var _rew_pivot : int
var _rew_bksp_count : int = 0

func get_alphabet_delay(c:String) -> int:
	match c:
		'.','!','?',';': return 15
		',',':': return 7
	return 2

func _ready():
	add_color_override("font_color", Color.white) # pure white
	self_modulate = palette.idle_colour

func _physics_process(_delta):
	
	bufs.process_bufs()
	
	if goaltext and _rewt2 != goaltext:
		_rewt2 = goaltext
		_rewt2_vis = visify(goaltext)
		_rewt2_vislen = len(_rewt2_vis)
		if text == _rewt2:
			typst.goto(TYPING)
		else:
			typst.goto(BKSPING)
			_rew_pivot = find_rew_pivot(text, _rewt2)
	
	if bufs.has(TYPE_PAUSE_BUF):
		pass
	else: match typst.id:
		BKSPING:
			if visible_characters < 0:
				visible_characters = len(visify(text))
			var spd = 1
			if visible_characters > _rew_pivot + 10: spd += 1
			if visible_characters > _rew_pivot + 20: spd += 1
			for _i in range(spd):
				if visible_characters <= _rew_pivot:
					typst.goto(TYPING)
					break
				else:
					visible_characters -= 1
					_rew_bksp_count += 1
		TYPING:
			if visible_characters >= 0 and visible_characters + 1 <= _rewt2_vislen:
				bufs.setmin(TYPE_PAUSE_BUF, get_alphabet_delay(_rewt2_vis[visible_characters]))
				visible_characters += 1
			else:
				typst.goto(DONE)
		DONE:
			if bufs.wasjustcleared(DONE_EXPIRY_BUF):
				typst.goto(IDLE)
	
	if goalcolour != colourlerp:
		if goalcolour > colourlerp:
			colourlerp = lerp(move_toward(colourlerp,goalcolour,palette.active_linspd),goalcolour,palette.active_mulspd)
		elif goalcolour < colourlerp:
			colourlerp = lerp(move_toward(colourlerp,goalcolour,palette.idle_linspd),goalcolour,palette.idle_mulspd)
		self_modulate = lerp(palette.idle_colour, palette.active_colour, colourlerp)
		
			
func find_rew_pivot(s1:String, s2:String)->int:
	var vs1 = visify(s1)
	var vs2 = visify(s2)
	var starting_matchlen : int = 0
	for i in range(min(len(vs1),len(vs2))):
		if vs1[i]==vs2[i]:
			starting_matchlen = i + 1
		else:
			break # done. not a match.
	return starting_matchlen
func visify(s:String)->String:
	return s.replace(' ','').replace('\n','')
