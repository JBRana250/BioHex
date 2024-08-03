extends Node

const EXISTING_CELL_IDLE = preload("res://Evolution Scene/Assets/Existing Cell/existing_cell_idle.tres")
const EXISTING_CELL_CORE_IDLE = preload("res://Evolution Scene/Assets/Existing Cell/existing_cell_core_idle.tres")
const EXISTING_CELL_HOVER = preload("res://Evolution Scene/Assets/Existing Cell/existing_cell_hover.tres")
const EXISTING_CELL_ACTIVE = preload("res://Evolution Scene/Assets/Existing Cell/existing_cell_active.tres")


var mouse_hovering: bool = false
var is_active: bool = false
@onready var properties = get_parent().get_node("Properties")

func _set_material_hover():
	for cell_mesh in properties.cell_meshes:
		cell_mesh.set_surface_override_material(0, EXISTING_CELL_HOVER)

func _set_material_idle():
	for cell_mesh in properties.cell_meshes:
		if cell_mesh.is_in_group("base"):
			cell_mesh.set_surface_override_material(0, EXISTING_CELL_IDLE)
		elif cell_mesh.is_in_group("core"):
			cell_mesh.set_surface_override_material(0, EXISTING_CELL_CORE_IDLE)

func _set_material_active():
	for cell_mesh in properties.cell_meshes:
		cell_mesh.set_surface_override_material(0, EXISTING_CELL_ACTIVE)

func onMouseEntered():
	if is_active == false:
		_set_material_hover()
	mouse_hovering = true

func onMouseExited():
	if is_active == false:
		_set_material_idle()
	mouse_hovering = false
	
func _ready():
	_set_material_idle()

func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		if mouse_hovering == true and Globals.active_cell_blueprint == null:
			_set_material_active()
			#show_UI_component.globalShowUI()
			is_active = true
			Globals.active_cell_blueprint = owner

