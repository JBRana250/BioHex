extends Node

var creature
@onready var cam_pivot: Node3D = creature.Dependencies["cam_pivot"]
@onready var creature_transform_basis: Node3D = creature.Dependencies["creature_transform_basis"]
@onready var spring_arm: SpringArm3D = creature.Dependencies["spring_arm"]
@onready var camera_3d: Camera3D = creature.Dependencies["camera_3d"]

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
		cam_pivot.rotation.y += (next_mouse_position.x - prev_mouse_position.x) * -cam_rotation_speed * delta
		creature_transform_basis.rotation.y += (next_mouse_position.x - prev_mouse_position.x) * -cam_rotation_speed * delta
		cam_pivot.rotation.x += (next_mouse_position.y - prev_mouse_position.y) * -cam_rotation_speed * delta
		#lock z rotation
		cam_pivot.rotation.z = 0
		cam_pivot.rotation.x = clamp(cam_pivot.rotation.x, deg_to_rad(-90), 0)
		prev_mouse_position = next_mouse_position
