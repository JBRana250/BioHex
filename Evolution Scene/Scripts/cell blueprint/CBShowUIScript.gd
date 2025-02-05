extends Node

@export var ui_scene_res_path: String
var UI_instance: Control
@export var properties: Node

func globalShowUI():
	if ui_scene_res_path.is_empty():
		print_debug("no ui scene res path provided")
		return
	UI_instance = load(ui_scene_res_path).instantiate()
	
	if properties.creature_part_blueprint:
		UI_instance.current_cell_position = properties.position
		UI_instance.current_part_position = properties.creature_part_position
		UI_instance.display_parts()
	
	UI.currently_active_ui.add_child(UI_instance)
	Globals.inside_menu = true

func globalHideUI():
	if is_instance_valid(UI_instance):
		UI_instance.queue_free()
	Globals.inside_menu = false
