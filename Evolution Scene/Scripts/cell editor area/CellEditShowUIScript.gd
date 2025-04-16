extends Node

const EVO_SCREEN_CELL_EDIT_UI = preload("res://Evolution Scene/Scenes/UI/evo_screen_cell_edit_ui.tscn")
var UI_instance: Control

@export var properties: Node

func globalShowUI():
	UI_instance = EVO_SCREEN_CELL_EDIT_UI.instantiate()
	
	UI_instance.cell_properties.cell_pos = properties.position
	
	if properties.position == Vector2(0,0):
		UI_instance.trash_button.queue_free()
	
	UI.currently_active_ui.display_vbox.add_child(UI_instance)

func globalHideUI():
	if is_instance_valid(UI_instance):
		UI_instance.queue_free()
