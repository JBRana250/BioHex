extends OnClickComponentScript

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	super(_camera, event, _position, _normal, _shape_idx)
	if Input.is_action_just_pressed("left_click") and attributes.eligible_to_travel:
				Globals.current_room_pos = attributes.room_pos
				Globals.current_row = attributes.row_num
				SceneSwitcher.switch_scene(attributes.res_path)
