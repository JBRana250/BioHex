extends Node

class_name CreatureManaComponent

var creature
@onready var mana_bar: Node3D = creature.Dependencies["mana_bar"]

@export var max_mana: float
@export var mana: float
@export var mana_efficiency: float

func InitMana(_mana):
	max_mana = _mana
	mana = _mana
	mana_bar.globalInitMana(mana, max_mana)

func globalDecreaseMana(value: float):
	mana -= value / mana_efficiency
	mana_bar.globalSetMana(mana)
