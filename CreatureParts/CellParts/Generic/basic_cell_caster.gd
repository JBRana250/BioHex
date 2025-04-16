extends Node3D

@export var creature_part_mesh: Node3D
@export var ranged_damage_component: Node

@export var basiccellcaster_mult: float

@export var base_damage: float:
	set(damage):
		if !is_instance_valid(ranged_damage_component):
			return
		ranged_damage_component.globalSetDamage(damage * basiccellcaster_mult)
