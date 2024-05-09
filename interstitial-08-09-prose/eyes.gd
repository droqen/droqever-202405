extends Area2D

var target_area2d : SpecialArea2D = null

func _physics_process(_delta):
	var smallest_area2d:SpecialArea2D = null
	var smallest_area2d_volume : float = 999999
	for area2d in get_overlapping_areas():
		if area2d is SpecialArea2D:
			var v = get_volume_of_area2d(area2d)
			if v < smallest_area2d_volume:
				smallest_area2d = area2d
				v = smallest_area2d_volume
	if target_area2d != smallest_area2d:
		target_area2d = smallest_area2d
		var look_result : String = ""
		if target_area2d: look_result = target_area2d.override_look()
		if look_result:
			var print_result = get_tree().call_group(
				"TEXTWIN",
				"printmessage",
				look_result
			)
			prints('print:',print_result)

func get_volume_of_area2d(a:SpecialArea2D) -> float:
	return a.get_volume()
