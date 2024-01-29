extends Node3D

@onready var camera_3d = Globals.camera
@export var mesh: MeshInstance3D
@export var show_UI_component: Node
var mouse_hovering: bool = false
var is_active: bool = false

func globalMouseEntered():
	if is_active == false:
		mesh.globalSetMaterialHover()
	mouse_hovering = true
	
func globalMouseExited():
	if is_active == false:
		mesh.globalSetMaterialIdle()
	mouse_hovering = false

func globalDeselectBlueprint():
	is_active = false
	mesh.globalSetMaterialIdle()
	show_UI_component.globalHideUI()

func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		if mouse_hovering == true and Globals.active_cell_blueprint == null:
			mesh.globalSetMaterialActive()
			show_UI_component.globalShowUI()
			is_active = true
			Globals.active_cell_blueprint = owner
