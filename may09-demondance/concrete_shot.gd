extends KinematicBody2D

var velocity : Vector2

func setup(dir,fliph):
#	position = parent.position
#	parent.get_parent().add_child(self)
#	owner = parent.owner
	velocity = dir.normalized() * 2.0
	$SheetSprite.flip_h = fliph
	return self

func _physics_process(_delta):
	var hit:KinematicCollision2D
	hit = move_and_collide(Vector2(velocity.x, 0))
	if hit: on_bonk(hit)
	else:
		hit = move_and_collide(Vector2(0, velocity.y))
		if hit: on_bonk(hit)

func on_bonk(hit:KinematicCollision2D):
	queue_free()
