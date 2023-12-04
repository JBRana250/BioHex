extends Node

@export var res_path: String
@onready var attributes = get_parent().find_child("RoomAttributes")


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and attributes.eligible_to_travel:
			Globals.current_room_pos = attributes.room_pos
			Globals.current_row = attributes.row_num
			SceneSwitcher.switch_scene(res_path)
