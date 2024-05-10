extends Area2D

var target_area2d : SpecialArea2D = null

func _physics_process(_delta):
	for area2d in get_overlapping_areas():
		if area2d is SpecialArea2D:
			PlayerStatus.imm_look(area2d.get_look(), area2d.get_intensity())
