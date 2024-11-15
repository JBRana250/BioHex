extends Node

@export var num_of_enemies: int

func _ready():
	EventManager.subscribe("EnemyDefeated", onEnemyDeath)
	
func onEnemyDeath(_event_data):
	num_of_enemies -= 1
	if num_of_enemies == 0:
		print("Victory!")
