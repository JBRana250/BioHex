extends Node3D

@export var show_UI_component: Node
@export var change_material_component: Node
@export var mouse_input_component: Node3D

@export var properties: Node

@export var area_3D: Area3D

var area_scene

func instantiate_editor_area():
	var area_scene_instance = area_scene.instantiate()
	
	area_3D.add_child(area_scene_instance)
