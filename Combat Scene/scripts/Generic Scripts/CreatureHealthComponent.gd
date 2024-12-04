extends Node

class_name CreatureHealthComponent

@export var health_bar: Node3D
@export var death_component: Node
@export var health: float

@export var already_dead: bool = false

func InitHealth():
	health_bar.globalInitHealth(health)

func globalDecreaseHealth(value: float):
	health -= value
	health_bar.globalSetHealth(health)
	if health <= 0 and !already_dead:
		death_component.Death()
		already_dead = true
