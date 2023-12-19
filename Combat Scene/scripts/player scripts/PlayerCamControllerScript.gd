extends Node

@onready var creature = owner.get_parent()

@onready var camera_3d: Camera3D = $"../../CameraPivot/SpringArm3D/Camera3D"
@onready var spring_arm: SpringArm3D = $"../../CameraPivot/SpringArm3D"
@onready var camera_pivot: Node3D = $"../../CameraPivot"

@export var cam_rotation_speed: float = 0.15

var cam_rotating: bool = false
var prev_mouse_position = Vector2()
var next_mouse_position = Vector2()

func globalSetCameraDistance(distance):
	camera_3d.position.z = distance
	spring_arm.spring_length = distance

func globalSetCamRotation(isRotating, prev_mouse_pos = Vector2()):
	cam_rotating = isRotating
	prev_mouse_position = prev_mouse_pos

func _process(delta):
	if(cam_rotating):
		next_mouse_position = get_viewport().get_mouse_position()
		creature.rotate_y((next_mouse_position.x - prev_mouse_position.x) * -cam_rotation_speed * delta)
		camera_pivot.rotate_x((next_mouse_position.y - prev_mouse_position.y) * -cam_rotation_speed * delta)
		#lock z rotation
		camera_pivot.rotation.z = 0
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-90), 0)
		prev_mouse_position = next_mouse_position
