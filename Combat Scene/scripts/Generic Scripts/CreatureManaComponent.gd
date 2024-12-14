extends Node

class_name CreatureManaComponent

var creature
@onready var mana_bar: Node3D = creature.Dependencies["mana_bar"]

@export var mana: float

func InitMana():
	mana = 100
	mana_bar.globalInitMana(mana)

func globalDecreaseMana(value: float):
	mana -= value
	mana_bar.globalSetMana(mana)
