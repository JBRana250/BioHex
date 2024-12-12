extends Node

class_name CreatureDamageComponent

@export var damage: float
@export var melee_weapons: Node3D
@export var ranged_weapons: Node3D

func InitDamage():
	for melee_weapon in melee_weapons.get_children():
		melee_weapon.base_damage = damage
	for ranged_weapon in ranged_weapons.get_children():
		ranged_weapon.base_damage = damage

func globalSetDamage(new_damage):
	damage = new_damage
	for melee_weapon in melee_weapons.get_children():
		melee_weapon.base_damage = damage
	for ranged_weapon in ranged_weapons.get_children():
		ranged_weapon.base_damage = damage
