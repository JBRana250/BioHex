extends Node

const EVO_SCREEN_UI = preload("res://Evolution Scene/Scenes/UI/evo_screen_ui.tscn")

func _ready():
	var ui_control_instance = EVO_SCREEN_UI.instantiate()
	UI.add_child(ui_control_instance)
	UI.currently_active_ui = ui_control_instance
