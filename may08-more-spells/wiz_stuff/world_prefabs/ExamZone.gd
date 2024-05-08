tool
extends BaseWizardInteractionArea
class_name ExamZone

export (String, MULTILINE) var intro_monologue = "TESTING"
export var down_interaction_prompt : bool = false

func _ready():
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(2, true) # detecting wiz (2=3)
	# i have no layer
	set_collision_layer_bit(0, false)
	
func _physics_process(_delta):
	if wiz: wiz.immediate_assign_action_target(self)

func get_display_text() -> String:
	return intro_monologue
