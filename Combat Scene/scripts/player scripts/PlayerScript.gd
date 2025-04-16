extends CharacterBody3D

@export var combat_room_cleared: Event

@export var player_inventory: PlayerInventory

var Dependencies: Dictionary = {
	
}

func _ready():
	Globals.player = self
	combat_room_cleared.connect("event_triggered", onCombatRoomCleared)

func onCombatRoomCleared():
	player_inventory.health = Dependencies['health_component'].health
	player_inventory.mana = Dependencies['mana_component'].mana
	combat_room_cleared.disconnect("event_triggered", onCombatRoomCleared)
