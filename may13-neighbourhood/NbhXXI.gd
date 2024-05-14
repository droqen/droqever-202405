extends Node2D

enum {
	UNDEFINED = 0,
	
	PLOT_STEP = 4000,
	PLOT_1_INTRO,
	PLOT_1_INTRO_PT2,
	PLOT_1_EXPLORE,
	PLOT_2_INTRO,
	PLOT_2_EXPLORE,
	PLOT_END,
	
	STAGE_NONE = 5000,
	STAGE_SOLODIALOG,
	STAGE_PLAY,
	STAGE_PLAYDIALOG,
}


onready var arcade = $arcade
onready var dialogbox = $dialogbox_small
onready var dialogbox_full = $dialogbox_full
onready var guy = $arcade/greyguy

onready var stagest = TinyState.new(STAGE_NONE, self, "mut_stagest")
onready var plotst = TinyState.new(PLOT_1_INTRO, self, "mut_plotst")

var screen_coord : Vector2 = Vector2(5, 5) # 5 is the middle.

func mut_stagest(a,b):
	if not (a in [STAGE_PLAY, STAGE_PLAYDIALOG]) and (b in [STAGE_PLAY, STAGE_PLAYDIALOG]):
		guy.reset()
	match b:
		STAGE_NONE: set_visible_screens([])
		STAGE_PLAY:
			set_visible_screens([arcade])
		STAGE_PLAYDIALOG:
			set_visible_screens([arcade, dialogbox])
			if guy.position.y < 100:
				dialogbox.dbst.goto(dialogbox.DISPLAYBOTTOM)
			else:
				dialogbox.dbst.goto(dialogbox.DISPLAYTOP)
		STAGE_SOLODIALOG:
			set_visible_screens([dialogbox_full])
			dialogbox_full.dbst.goto(dialogbox_full.DISPLAY)
		_: 
			set_visible_screens([])
			push_error("unknown stagest "+str(b))
func mut_plotst(_a,b):
	stagest.goto(STAGE_NONE)
	match b:
		PLOT_1_INTRO:
			dialogbox_full.set_message("In the pitch black darkness of the time before time, you were a stone. When time was born, you were a stone. And even now that there is a now, you remain a stone.")
			stagest.goto(STAGE_SOLODIALOG, true)
		PLOT_1_INTRO_PT2:
			dialogbox_full.set_message("Open your eyes, stone.")
			stagest.goto(STAGE_SOLODIALOG, true)
		PLOT_1_EXPLORE:
			apply_level_data("res://levels/level_hub_plot1.tscn", Vector2(5,5), Vector2(73,105))
			guy.reset()
			stagest.goto(STAGE_PLAY)

func set_visible_screens(screens):
	set_screen_vis(arcade, arcade in screens)
	set_screen_vis(dialogbox, dialogbox in screens)
	set_screen_vis(dialogbox_full, dialogbox_full in screens)
func set_screen_vis(screen : Node, vis):
	screen.call('show' if vis else 'hide')
	screen.set_process(vis)

func _on_greyguy_read(target):
	dialogbox.set_message(target.examination_message)
	stagest.goto(STAGE_PLAYDIALOG)

func _on_dialogbox_small_exited():
	if stagest:
		match stagest.id:
			STAGE_SOLODIALOG:
				plotst.goto(plotst.id + 1)
			STAGE_PLAYDIALOG:
				guy.ggst.call_deferred("goto", guy.AIR)
				stagest.goto(STAGE_PLAY)

func _physics_process(_delta):
	var dx : int = 0
	var dy : int = 0
	if guy.position.x < 4: dx = -1
	if guy.position.x > 196: dx = 1
	if guy.position.y < 4: dy = -1
	if guy.position.y > 196: dy = 1
	if dx or dy:
		var sc2 = screen_coord + Vector2(dx, dy)
		var level_data = get_level_at(sc2)
		if len(level_data) >= 2: sc2 = level_data[1]
		apply_level_data(level_data[0], sc2, guy.position - Vector2(dx,dy) * 192)
	if stagest.id == STAGE_PLAYDIALOG:
		guy.proc_reading()

func apply_level_data(level_path, new_screen_coord, new_guy_position):
	var new_level = load(level_path).instance()
	for child in $arcade/levelloader.get_children():
		child.queue_free()
	$arcade/levelloader.add_child(new_level)
	new_level.owner = owner if owner else self
	screen_coord = new_screen_coord
	guy.position = new_guy_position

func get_level_at(screen_coord, stack = 0):
	var xy : int = int(round(screen_coord.x)) * 10 + int(round(screen_coord.y))
	match xy:
		45: return ["res://levels/level_4_5_bare_plain.tscn"]
		55: return ["res://levels/level_hub_plot1.tscn"]
		_ : return ["res://levels/level_5_4_darkness_above.tscn", Vector2(5,4)]
