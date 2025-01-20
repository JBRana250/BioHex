extends Node

class_name CreatureDamageComponent

var creature
@onready var body = creature.Dependencies["body"]
@onready var melee_weapons: Node3D = creature.Dependencies["melee_weapons"]
@onready var ranged_weapons: Node3D = creature.Dependencies["ranged_weapons"]

var damage: float

@export var creature_inventory: CreatureInventory
@export var stat_calculator: Node

func _find_max_mana_based_damage_increase():
	var max_mana = stat_calculator._calculate_max_mana()
	var max_mana_based_damage = stat_calculator._calculate_max_mana_based_damage()
	
	return max_mana * max_mana_based_damage

func InitDamage(_damage):
	damage = stat_calculator._calculate_damage()
	
	if len(creature_inventory.max_mana_based_damage_mods) > 0:
		damage += _find_max_mana_based_damage_increase()
	
	for melee_weapon in melee_weapons.get_children():
		melee_weapon.base_damage = damage
	for ranged_weapon in ranged_weapons.get_children():
		ranged_weapon.base_damage = damage

#func globalSetDamage(new_damage):
	#damage = new_damage
	#for melee_weapon in melee_weapons.get_children():
		#melee_weapon.base_damage = damage
	#for ranged_weapon in ranged_weapons.get_children():
		#ranged_weapon.base_damage = damage
