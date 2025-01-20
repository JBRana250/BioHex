extends Node

const EVO_SCREEN_CELL_BLUEPRINT_UI = preload("res://Evolution Scene/Scenes/UI/evo_screen_cell_blueprint_UI.tscn")
var UI_instance: VBoxContainer

func globalShowUI():
	UI_instance = EVO_SCREEN_CELL_BLUEPRINT_UI.instantiate()
	UI.currently_active_ui.margin_container.add_child(UI_instance)

func globalHideUI():
	if is_instance_valid(UI_instance):
		UI_instance.queue_free()
