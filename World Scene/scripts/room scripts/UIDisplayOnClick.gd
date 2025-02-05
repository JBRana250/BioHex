extends OnClickComponentScript

class_name UIDisplayOnClickScript

var ui_instance: Control
var already_clicked: bool = false

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("left_click") and attributes.eligible_to_travel and !already_clicked:
			Globals.rooms_cleared += 1
			already_clicked = true
			Globals.current_room_pos = attributes.room_pos
			Globals.current_row = attributes.row_num
			
			var ui = load(attributes.res_path)
			ui_instance = ui.instantiate()
			UI.add_child(ui_instance)
