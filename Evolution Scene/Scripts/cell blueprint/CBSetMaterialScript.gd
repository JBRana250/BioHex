extends MeshInstance3D

const BASIC_CELL_BLUEPRINT_IDLE_MATERIAL = preload("res://Evolution Scene/Assets/Cell Part Blueprints/blueprint_idle.tres")
const BASIC_CELL_BLUEPRINT_HOVER = preload("res://Evolution Scene/Assets/Cell Part Blueprints/blueprint_hover.tres")
const BASIC_CELL_BLUEPRINT_ACTIVE = preload("res://Evolution Scene/Assets/Cell Part Blueprints/blueprint_active.tres")

func _set_material_active():
	set_surface_override_material(0, BASIC_CELL_BLUEPRINT_ACTIVE)

func _set_material_hover():
	set_surface_override_material(0, BASIC_CELL_BLUEPRINT_HOVER)

func _set_material_idle():
	set_surface_override_material(0, BASIC_CELL_BLUEPRINT_IDLE_MATERIAL)
