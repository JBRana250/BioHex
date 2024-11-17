extends Node

@export var num_of_enemies: int
@export var victory_ui: Control

func _ready():
	EventManager.subscribe("EnemyDefeated", onEnemyDeath)
	
func onEnemyDeath(_event_data):
	num_of_enemies -= 1
	if num_of_enemies == 0:
		victory_ui.show()
		EventManager.unsubscribe("EnemyDefeated", onEnemyDeath)
