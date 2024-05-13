extends Node2D

var life : int = 22
var strength : int = 4

func setup(faceleft, ydir):
	position += Vector2(-10 if faceleft else 10, 5 * ydir - 2)
	$SheetSprite.flip_h = faceleft
	return self

func _physics_process(_delta):
	if life > 0:
		life -= 1
	else:
		queue_free()


func _on_fireHitArea_body_entered(body):
	if body.has_method("extinguish"):
		body.extinguish(strength)
		strength -= 1
