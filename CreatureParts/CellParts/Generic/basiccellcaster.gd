extends Node3D

@export var ranged_damage_component: Node

@export var basiccellcaster_mult: float

@export var base_damage: float:
	set(damage):
		ranged_damage_component.globalSetDamage(damage * basiccellcaster_mult)
