extends Node

const WORLD_SCENE_UI = preload("res://World Scene/scenes/world_scene_ui.tscn")

func _ready():
	var ui_instance = WORLD_SCENE_UI.instantiate()
	UI.add_child(ui_instance)
	UI.currently_active_ui = ui_instance
