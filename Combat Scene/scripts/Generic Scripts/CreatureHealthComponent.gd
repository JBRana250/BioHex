extends Node

class_name CreatureHealthComponent

@export var death_component: Node
@export var health: float

func globalDecreaseHealth(value: float):
	health -= value
	if health <= 0:
		death_component.Death()
