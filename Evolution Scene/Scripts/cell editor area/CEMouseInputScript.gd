extends Node

const EXISTING_CELL_IDLE = preload("res://Evolution Scene/Assets/Existing Cell/existing_cell_idle.tres")
const EXISTING_CELL_CORE_IDLE = preload("res://Evolution Scene/Assets/Existing Cell/existing_cell_core_idle.tres")
const EXISTING_CELL_HOVER = preload("res://Evolution Scene/Assets/Existing Cell/existing_cell_hover.tres")
const EXISTING_CELL_ACTIVE = preload("res://Evolution Scene/Assets/Existing Cell/existing_cell_active.tres")

@export var show_UI_component: Node

var mouse_hovering: bool = false
var is_active: bool = false
@export var is_creature_part_editor_area: bool = false
@onready var properties = get_parent().get_node("Properties")

func _set_material_hover():
	for cell_mesh in properties.cell_meshes:
		cell_mesh.set_surface_override_material(0, EXISTING_CELL_HOVER)

func _set_material_idle():
	for cell_mesh in properties.cell_meshes:
		if is_creature_part_editor_area:
			cell_mesh.set_surface_override_material(0, null)
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

func globalDeselectBlueprint():
	is_active = false
	_set_material_idle()
	show_UI_component.globalHideUI()

func _input(_event):
	if mouse_hovering == false:
			return
	if Input.is_action_just_pressed("left_click"):
		var active_blueprint = Globals.active_cell_blueprint
		
		# if there is already an active blueprint:
		if active_blueprint != null:
			active_blueprint.show_UI_component.globalHideUI()
			active_blueprint.change_material_component._set_material_idle()
			active_blueprint.mouse_input_component.is_active = false
		
		_set_material_active()
		show_UI_component.globalShowUI()
		
		var display_manager = get_tree().current_scene.display_manager
		display_manager.globalHideCellBlueprints()
		display_manager.globalDisplayPossibleCreatureParts(properties.position, properties.has_core_creature_part, properties.outer_creature_part_positions)
		
		is_active = true
		Globals.active_cell_blueprint = owner
