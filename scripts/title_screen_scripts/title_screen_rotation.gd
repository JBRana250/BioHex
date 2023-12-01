extends Node3D

@export var rotation_speed: float = 1.25
	
func _process(delta):
	rotation_speed = randf_range(0.75,1.75)
	rotation += Vector3(rotation_speed * delta, rotation_speed * delta, rotation_speed * delta)
