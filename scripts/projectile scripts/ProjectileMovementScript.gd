extends Node

@export var bullet_speed: float = 0
@export var direction = Vector3()

func _process(delta):
	owner.linear_velocity = direction * bullet_speed * delta
