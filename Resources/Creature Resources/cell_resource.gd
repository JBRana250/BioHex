extends Resource

class_name Cell_Resource

@export var Name: String
@export var parent_cell_position_array: Array[Vector2]
@export var child_cell_position_array: Array[Vector2]
@export var position: Vector2
@export var weight: int
@export var core_component: Core_Component_Resource
@export var inner_components: Array[Inner_Component_Resource]
@export var outer_components: Array[Outer_Component_Resource]
@export var health_resource: Creature_Part_Health_Resource
@export var scene_resource: Creature_Part_Scene_Resource
