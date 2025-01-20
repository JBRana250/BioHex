extends Node

class_name CreatureHealthComponent

var creature
@onready var health_bar: Node3D = creature.Dependencies["health_bar"]
@export var death_component: Node

@export var max_health: float
@export var health: float
@export var already_dead: bool = false

@export var defence: float = 1

@export var stat_calculator: Node

func InitHealth(_health):
	max_health = _health
	max_health = stat_calculator._calculate_max_health(max_health)
	health = max_health
	health_bar.globalInitHealth(health, max_health)

func globalDecreaseHealth(value: float):
	var health_decrement = value - defence
	if health_decrement < 0:
		health_decrement = 0
	health -= health_decrement
	health_bar.globalSetHealth(health)
	if health <= 0 and !already_dead:
		death_component.Death()
		already_dead = true
