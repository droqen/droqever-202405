tool
extends Container

export (DynamicFont) var scalablefont1 : DynamicFont = null
export (int) var scalablefont1_base_size : int = 10
export (DynamicFont) var scalablefont2 : DynamicFont = null
export (int) var scalablefont2_base_size : int = 5
export (int) var scalable_margin = 10
export (int) var scalable_margin_top = 0
export (int) var scalable_margin_left = 0
export (int) var scalable_margin_right = 0
export (int) var scalable_margin_bottom = 0

enum { X_AXIS, Y_AXIS }

func set_rect_and_scale(r : Rect2, s : int):
	
	for mar_ax_pos in [
		[scalable_margin_top, Y_AXIS, true],
		[scalable_margin_bottom, Y_AXIS, false],
		[scalable_margin_left, X_AXIS, true],
		[scalable_margin_right, X_AXIS, false],
	]:
		var mar = mar_ax_pos[0]
		var ax = mar_ax_pos[1]
		var pos = mar_ax_pos[2]
		var total_mar = s * (scalable_margin + mar)
		match ax:
			X_AXIS:
				if pos: r.position.x += total_mar
				r.size.x -= total_mar
			Y_AXIS:
				if pos: r.position.y += total_mar
				r.size.y -= total_mar
	
	fit_child_in_rect(get_child(0), r)
	get_child(0).rect_min_size = r.size
	if scalablefont1: scalablefont1.size = scalablefont1_base_size * s
	if scalablefont2: scalablefont2.size = scalablefont2_base_size * s

func _on_ViewportWrapperContainer_rect_and_scale_changed(rect, scale):
	set_rect_and_scale(rect, scale)
