extends Node

class_name CreatureManaComponent

var creature
@onready var mana_bar: Node3D = creature.Dependencies["mana_bar"]

@export var max_mana: float
@export var mana: float
@export var mana_efficiency: float = 1

@export var creature_inventory: CreatureInventory
@export var stat_calculator: Node

func InitMana(_mana):
	max_mana = stat_calculator._calculate_max_mana()
	mana = creature_inventory.mana
	
	mana_efficiency = stat_calculator._calculate_mana_efficiency()
	
	mana_bar.globalInitMana(mana, max_mana)

func globalDecreaseMana(value: float):
	mana -= value / mana_efficiency
	mana = clamp(mana, 0, max_mana)
	mana_bar.globalSetMana(mana)

func globalIncreaseMana(value: float):
	mana += value
	mana = clamp(mana, 0, max_mana)
	mana_bar.globalSetMana(mana)
