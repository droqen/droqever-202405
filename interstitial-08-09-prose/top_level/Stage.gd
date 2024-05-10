extends Control

# IN THEORY FACILITATES AND SETS UP CONNECTIONS BETWEEN TOP LEVEL CHILDREN.
# IN PRACTICE? WHATEVER

func _ready():
	$m/flexgrid/ViewportWrapperContainer.connect(
		"rect_and_scale_changed",
		$m/flexgrid/matching,
		"_on_ViewportWrapperContainer_rect_and_scale_changed"
	)
