extends Node

const TITLE_SCREEN_MENU = preload("res://Title Screen/title_screen_menu.tscn")
var menu_instance: Control

func _ready():
	menu_instance = TITLE_SCREEN_MENU.instantiate()
	Globals.user_interface.add_child(menu_instance)
