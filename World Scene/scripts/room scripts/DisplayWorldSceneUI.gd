extends Node

const WORLD_SCENE_UI = preload("res://World Scene/scenes/world_scene_ui.tscn")
var menu_instance: Control

func _ready():
	menu_instance = WORLD_SCENE_UI.instantiate()
	Globals.user_interface.add_child(menu_instance)
