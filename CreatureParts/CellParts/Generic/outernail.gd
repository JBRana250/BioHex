extends Node3D

@export var melee_damage_component: Node
@export var outernail_damage_mult: float

@export var base_damage: float:
	set(damage):
		melee_damage_component.globalSetDamage(damage * outernail_damage_mult)
