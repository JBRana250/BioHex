extends MeshInstance3D

const BASIC_CELL_BLUEPRINT_IDLE_MATERIAL = preload("res://Evolution Scene/Assets/Cell Part Blueprints/basic_cell_blueprint_idle_material.tres")
const BASIC_CELL_BLUEPRINT_HOVER = preload("res://Evolution Scene/Assets/Cell Part Blueprints/basic_cell_blueprint_hover.tres")
const BASIC_CELL_BLUEPRINT_ACTIVE = preload("res://Evolution Scene/Assets/Cell Part Blueprints/basic_cell_blueprint_active.tres")

func globalSetMaterialActive():
	set_surface_override_material(0, BASIC_CELL_BLUEPRINT_ACTIVE)

func globalSetMaterialHover():
	set_surface_override_material(0, BASIC_CELL_BLUEPRINT_HOVER)

func globalSetMaterialIdle():
	set_surface_override_material(0, BASIC_CELL_BLUEPRINT_IDLE_MATERIAL)
