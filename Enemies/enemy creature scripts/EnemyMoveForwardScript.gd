extends Node

var creature
@onready var body = creature.Dependencies["body"]
@export var movement_component: Node
@export var rotation_component: Node


func _process(_delta):
	if !is_instance_valid(body):
		return
	movement_component.globalSetMovementDirection(Vector2(body.transform.basis.z.x, body.transform.basis.z.z))
	
	#if the angle between direction creature is facing and the player is large, result in slower speed. smaller angle -> more speed. No angle -> max speed.
	var angle = abs(rotation_component.globalGetAngleBetweenForwardAndDesiredDirection())
	var speed_decrement = angle * 5
	
	movement_component.max_speed = 7 - speed_decrement
	if movement_component.max_speed < 0:
		movement_component.max_speed = 0
