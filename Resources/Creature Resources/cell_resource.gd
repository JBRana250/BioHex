extends Resource

class_name Cell_Resource

@export var Name: String
@export var position: Vector2
@export var weight: int
@export var adjacent_cell_array: Array[Cell_Resource]
@export var core_creature_part: Core_Creature_Part_Resource
@export var inner_creature_parts: Array[Inner_Creature_Part_Resource]
@export var outer_creature_parts: Array[Outer_Creature_Part_Resource]
@export var health_resource: Creature_Part_Health_Resource
@export var scene_resource: Creature_Part_Scene_Resource
