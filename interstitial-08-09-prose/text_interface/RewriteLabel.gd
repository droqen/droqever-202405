extends Label
class_name RewriteLabel

export(String,MULTILINE)var goaltext:String

enum { IDLE, BKSPING, TYPING, DONE,
	TYPE_PAUSE_BUF, }
onready var bufs = Bufs.new([[TYPE_PAUSE_BUF,20]])
onready var typst = TinyState.new(BKSPING, self, "mut_typst")
func mut_typst(_a,b):
	match b:
		IDLE:
			pass # set colour to idle
		BKSPING:
			if visible_characters < 0:
				visible_characters = len(visify(text))
		TYPING:
			bufs.on(TYPE_PAUSE_BUF)
			text = _rewt2
			visible_characters = _rew_pivot
		DONE:
			pass # ok just stop i guess?? same as idle but w/o colour

var _rewt2 : String
var _rewt2_vis : String
var _rewt2_vislen : int
var _rew_pivot : int

func get_alphabet_delay(c:String) -> int:
	match c:
		'.','!','?',';': return 15
		',',':': return 7
	return 2

func _physics_process(_delta):
	
	bufs.process_bufs()
	
	if _rewt2 != goaltext:
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
			if visible_characters <= _rew_pivot:
				typst.goto(TYPING)
			else:
				visible_characters -= 1
		TYPING:
			if visible_characters >= 0 and visible_characters + 1 <= _rewt2_vislen:
				bufs.setmin(TYPE_PAUSE_BUF, get_alphabet_delay(_rewt2_vis[visible_characters]))
				visible_characters += 1
			else:
				typst.goto(DONE)
			
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
