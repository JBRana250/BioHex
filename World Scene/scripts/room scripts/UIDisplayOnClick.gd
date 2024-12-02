extends Node

@onready var attributes = get_parent().get_node("RoomAttributes")
@export var ui_res_path: String

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("left_click") and attributes.eligible_to_travel:
			Globals.current_room_pos = attributes.room_pos
			Globals.current_row = attributes.row_num
			
			var ui = load(ui_res_path)
			var ui_instance = ui.instantiate()
			Globals.user_interface.add_child(ui_instance)
			ui_instance.keys_needed = attributes.keys_needed
			ui_instance._assign_key_labels()
