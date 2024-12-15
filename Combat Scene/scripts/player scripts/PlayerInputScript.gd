extends Node

@export var ranged_weapons_shooter: Node
@export var movement_component: Node
@export var player_camera_controller: Node
@export var mana_component: Node

@export var input_dir: Vector2
@export var movement_input_sum: float
@export var campos: int = 10
@export var springlength: int = 10

func _ChangeCamDistance(change):
	campos += change
	springlength += change
	campos = clamp(campos, 5, 20)
	player_camera_controller.globalSetCameraDistance(campos)

func _move_creature(input_dir):
	if mana_component.mana <= 0:
		movement_component.globalSetMovementDirection(Vector2())
		return
	movement_input_sum = abs(input_dir.x) + abs(input_dir.y)
	mana_component.globalDecreaseMana(movement_input_sum * 0.01)
	movement_component.globalSetMovementDirection(input_dir)
	
func _input(_event):
	#Left click inputs
	if Input.is_action_just_pressed("left_click"):
		ranged_weapons_shooter.globalSetFiring(true)

	if Input.is_action_just_released("left_click"):
		ranged_weapons_shooter.globalSetFiring(false)
		
	#Camera Controls
	if Input.is_action_pressed("zoom_out"):
		_ChangeCamDistance(1)

	if Input.is_action_pressed("zoom_in"):
		_ChangeCamDistance(-1)

	if Input.is_action_just_pressed("right_click"):
		player_camera_controller.globalSetCamRotation(true, get_viewport().get_mouse_position())

	if Input.is_action_just_released("right_click"):
		player_camera_controller.globalSetCamRotation(false)

	#Movement input
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_move_creature(input_dir)
