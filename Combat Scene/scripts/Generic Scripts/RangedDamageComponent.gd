extends Node

@export var damage: float
@export var owner_alignment = "Player"

func globalSetDamage(newDamage):
	damage = newDamage
