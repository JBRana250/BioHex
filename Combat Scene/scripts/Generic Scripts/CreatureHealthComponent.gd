extends Node

class_name CreatureHealthComponent

var creature
@onready var health_bar: Node3D = creature.Dependencies["health_bar"]
@export var death_component: Node

@export var max_health: float
@export var health: float
@export var already_dead: bool = false

func InitHealth(_health):
	max_health = _health
	health = _health
	health_bar.globalInitHealth(health, max_health)

func globalDecreaseHealth(value: float):
	health -= value
	health_bar.globalSetHealth(health)
	if health <= 0 and !already_dead:
		death_component.Death()
		already_dead = true
