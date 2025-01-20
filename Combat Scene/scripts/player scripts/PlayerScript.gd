extends CharacterBody3D

@export var player_inventory: PlayerInventory

var Dependencies: Dictionary = {
	
}

func _ready():
	Globals.player = self
	EventManager.subscribe("CombatRoomCleared", onCombatRoomCleared)

func onCombatRoomCleared(_event_data):
	player_inventory.health = Dependencies['health_component'].health
	player_inventory.mana = Dependencies['mana_component'].mana
	EventManager.unsubscribe("CombatRoomCleared", onCombatRoomCleared)
