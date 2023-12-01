extends Node

@export var damage: float = 2.5
@export var owner_alignment = "Player"

func globalSetDamage(newDamage):
	damage = newDamage
