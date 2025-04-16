extends Node

@export var player_inventory: PlayerInventory
@export var player_stat_calculator: Node
@export var mana_component: Node

var gain_mana: bool = false

@export var enemy_defeated: Event
@export var player_defeated: Event
@export var combat_room_cleared: Event

func _gain_mana():
	var max_mana_percent_gained = player_stat_calculator._calculate_max_mana_percent_on_kill()
	var max_mana = player_stat_calculator._calculate_max_mana()
	var mana_gained = max_mana * (max_mana_percent_gained / 100)
	mana_component.globalIncreaseMana(mana_gained)

func onEnemyDefeated():
	if gain_mana:
		_gain_mana()

func onPlayerDefeated():
	enemy_defeated.disconnect("event_triggered", onEnemyDefeated)
	player_defeated.disconnect("event_triggered", onPlayerDefeated)
	combat_room_cleared.disconnect("event_triggered", onCombatRoomCleared)

func onCombatRoomCleared():
	enemy_defeated.disconnect("event_triggered", onEnemyDefeated)
	player_defeated.disconnect("event_triggered", onPlayerDefeated)
	combat_room_cleared.disconnect("event_triggered", onCombatRoomCleared)

func _ready():
	gain_mana = false
	if !player_inventory.max_mana_percent_on_kill_mods.is_empty():
		gain_mana = true
		enemy_defeated.connect("event_triggered", onEnemyDefeated)
		player_defeated.connect("event_triggered", onPlayerDefeated)
		combat_room_cleared.connect("event_triggered", onCombatRoomCleared)
