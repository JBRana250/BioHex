extends Camera3D

func _input(event):
	if Input.is_action_just_pressed("right_click"):
		_SetCamRotation(true, get_viewport().get_mouse_position())

	if Input.is_action_just_released("right_click"):
		_SetCamRotation(false)
