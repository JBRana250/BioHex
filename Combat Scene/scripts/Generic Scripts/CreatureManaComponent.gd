extends Node

class_name CreatureManaComponent

@export var mana_bar: Node3D
@export var mana: float

func InitMana():
	mana = 100
	mana_bar.globalInitMana(mana)

func globalDecreaseMana(value: float):
	mana -= value
	mana_bar.globalSetMana(mana)
