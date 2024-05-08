extends Node2D

func setup():
	$CPUParticles2D.emitting = true
	return self
func _physics_process(_delta):
	if not $CPUParticles2D.emitting: queue_free()
