extends Area2D
var blink : int = 0
var target : Node2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var gg = get_parent()
	target = null
	hide()
	for area in get_overlapping_areas():
		target = area.get_parent()
		if target.get('hidden_indicator'): hide()
		elif blink >= 0 and blink < 15: show()
		else: hide()
		break
	match gg.ggst.id:
		gg.CHECK, gg.READING:
			blink = -1
			for area in get_overlapping_areas():
				target = area.get_parent()
		gg.AIR:
			blink = -1
		gg.STAND, gg.WALK:
			if blink < 0 or target == null: blink = 0
			else: blink = posmod(blink+1,30)
	if blink > 7: position.y = 2
	else: position.y = 1
