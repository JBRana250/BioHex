extends Node

@export var player_inventory: PlayerInventory
@export var player_stat_calculator: Node
@export var mana_component: Node

var gain_mana: bool = false

func _gain_mana():
	var max_mana_percent_gained = player_stat_calculator._calculate_max_mana_percent_on_kill()
	var max_mana = player_stat_calculator._calculate_max_mana()
	var mana_gained = max_mana * (max_mana_percent_gained / 100)
	mana_component.globalIncreaseMana(mana_gained)

func onEnemyDefeated(_event_data):
	if gain_mana:
		_gain_mana()

func onCombatRoomCleared(_event_data):
	EventManager.unsubscribe("EnemyDefeated", onEnemyDefeated)
	EventManager.unsubscribe("CombatRoomCleared", onCombatRoomCleared)
	EventManager.unsubscribe("PlayerDefeated", onPlayerDefeated)

func onPlayerDefeated(_event_data):
	EventManager.unsubscribe("EnemyDefeated", onEnemyDefeated)
	EventManager.unsubscribe("CombatRoomCleared", onCombatRoomCleared)
	EventManager.unsubscribe("PlayerDefeated", onPlayerDefeated)

func _ready():
	gain_mana = false
	if !player_inventory.max_mana_percent_on_kill_mods.is_empty():
		gain_mana = true
		EventManager.subscribe("EnemyDefeated", onEnemyDefeated)
		EventManager.subscribe("CombatRoomCleared", onCombatRoomCleared)
		EventManager.subscribe("PlayerDefeated", onPlayerDefeated)
