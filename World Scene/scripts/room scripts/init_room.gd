extends Node3D

class_name InitRoom

func _ready():
	find_child("Components").find_child("Attributes")._init_attributes()
	find_child("Components").find_child("Appearance")._init_appearance()
