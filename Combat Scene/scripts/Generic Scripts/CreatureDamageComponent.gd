extends Node

class_name CreatureDamageComponent

var creature
@onready var body = creature.Dependencies["body"]
@onready var melee_weapons: Node3D = creature.Dependencies["melee_weapons"]
@onready var ranged_weapons: Node3D = creature.Dependencies["ranged_weapons"]

@export var damage: float

func InitDamage(_damage):
	damage = _damage
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
