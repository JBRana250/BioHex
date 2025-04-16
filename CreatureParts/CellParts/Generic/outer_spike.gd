extends Node3D

@export var creature_part_mesh: Node3D

@export var melee_damage_component: Node
@export var outernail_damage_mult: float
var is_ready: bool = false

@export var base_damage: float:
	set(damage):
		if is_ready:
			melee_damage_component.globalSetDamage(damage * outernail_damage_mult)

func _ready():
	is_ready = true
	melee_damage_component.globalSetDamage(base_damage * outernail_damage_mult)
