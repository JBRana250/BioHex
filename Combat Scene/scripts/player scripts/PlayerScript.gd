extends CharacterBody3D

var Dependencies: Dictionary = {
	
}

func _ready():
	Globals.player = self
	EventManager.subscribe("CombatRoomCleared", onCombatRoomCleared)

func onCombatRoomCleared(_event_data):
	PlayerResources.health = Dependencies['health_component'].health
	PlayerResources.mana = Dependencies['mana_component'].mana
	EventManager.unsubscribe("CombatRoomCleared", onCombatRoomCleared)
