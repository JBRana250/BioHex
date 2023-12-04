extends Camera3D

@export var cam_rotating: bool
@export var prev_mouse_position: Vector2
@export var next_mouse_position: Vector2

@export var cam_rotation_speed: float = 0.15

@onready var camera_pivot = get_parent()


func _SetCamRotation(isRotating, prev_mouse_pos = Vector2()):
	cam_rotating = isRotating
	prev_mouse_position = prev_mouse_pos


func _input(_event):
	if Input.is_action_pressed("zoom_out"):
		position.z += 0.1

	if Input.is_action_pressed("zoom_in"):
		position.z -= 0.1
		
	if Input.is_action_just_pressed("right_click"):
		_SetCamRotation(true, get_viewport().get_mouse_position())

	if Input.is_action_just_released("right_click"):
		_SetCamRotation(false)
	
	position.z = clamp(position.z, 3, 4)

func _process(delta):
	if(cam_rotating):
		next_mouse_position = get_viewport().get_mouse_position()
		camera_pivot.rotate_y((next_mouse_position.x - prev_mouse_position.x) * -cam_rotation_speed * delta)
		camera_pivot.rotate_x((next_mouse_position.y - prev_mouse_position.y) * -cam_rotation_speed * delta)
		
		#lock z rotation
		camera_pivot.rotation.z = 0
		prev_mouse_position = next_mouse_position
