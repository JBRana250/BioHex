extends Node

@export var Enemies: Array[EnemyDrop]

@export var num_of_enemies: int
@export var victory_ui: Control

@export var player_inventory: PlayerInventory

@export var player_stat_calculator: Node

func _ready():
	EventManager.subscribe("EnemyDefeated", onEnemyDeath)

func _get_rand_resource(weights):
	var gold_weight = weights["Gold"]
	var claw_weight = weights["Claw"]
	var hoof_weight = weights["Hoof"]
	var scale_weight = weights["Scale"]
	var shard_weight = weights["Shard"]
	var essence_weight = weights["Essence"]
	
	var total_weight = gold_weight + claw_weight + hoof_weight + scale_weight + shard_weight + essence_weight
	
	var accumulator = {}
	var accumulated_weight = 0
	for restype in weights.keys():
		accumulated_weight += weights[restype]
		accumulator[restype] = accumulated_weight
		
	var randnum = randi_range(0, total_weight)
	for restype in accumulator.keys():
		var value = accumulator[restype]
		if value >= randnum:
			return restype

func _get_key() -> bool:
	var randnum = randi_range(0,100)
	if player_inventory.pkey > randnum:
		return true
	else:
		return false

func _calculate_and_increase_resources():
	var resources_gained = {
		"Gold": 0,
		"Claw": 0,
		"Hoof": 0,
		"Scale": 0,
		"Shard": 0,
		"Essence": 0,
		"Key": 0
	}

	for enemy in Enemies:
		for i in range(enemy.num_of_drops):
			var weights = {
				"Gold": enemy.gold_weight,
				"Claw": enemy.claw_weight,
				"Hoof": enemy.hoof_weight,
				"Scale": enemy.scale_weight,
				"Shard": enemy.shard_weight,
				"Essence": enemy.essence_weight
			}
			var resource_type = _get_rand_resource(weights)
			match resource_type:
				"Gold":
					player_inventory.gold += 1
				"Claw":
					player_inventory.claws += 1
				"Hoof":
					player_inventory.hoofs += 1
				"Scale":
					player_inventory.scales += 1
				"Shard":
					player_inventory.shards += 1
				"Essence":
					player_inventory.essence += 1
				_:
					print_debug("invalid resource gained?!?")
			
			resources_gained[resource_type] += 1
	
	if _get_key():
		player_inventory.keys += 1
		player_inventory.pkey = 0
		resources_gained["Key"] = 1
	else:
		player_inventory.pkey += 25
	
	return resources_gained

func _recover_mana():
	var mana_recovery_percent = player_stat_calculator._calculate_combat_end_mana_recovery_percent()
	
	var max_mana = player_stat_calculator._calculate_max_mana()
	
	var mana_recovered = max_mana * (mana_recovery_percent / 100)
	
	player_inventory.mana += mana_recovered

func _gain_gold_random():
	var coin_gain_percent = player_stat_calculator._calculate_combat_end_coin_gain_percent()
	var coin_gain_percent_divided = coin_gain_percent / 100
	var decimal = coin_gain_percent_divided - floor(coin_gain_percent_divided)
	
	var guaranteed_coins = coin_gain_percent_divided - decimal
	
	var rand_num = randi_range(1, 100)
	
	if rand_num >= (decimal * 100):
		guaranteed_coins += 1
	
	player_inventory.gold += guaranteed_coins
	return guaranteed_coins

func onEnemyDeath(_event_data):
	num_of_enemies -= 1
	if num_of_enemies == 0:
		#room has been cleared
		EventManager.unsubscribe("EnemyDefeated", onEnemyDeath)
		EventManager.broadcast_event("CombatRoomCleared", {})
		
		var resources_gained = _calculate_and_increase_resources()
		
		if !player_inventory.combat_end_mana_recovery_percent_mods.is_empty():
			_recover_mana()
		if !player_inventory.combat_end_coin_gain_percent_mods.is_empty():
			resources_gained["Gold"] += _gain_gold_random()
		
		victory_ui.resources_gained = resources_gained
		victory_ui.globalShowVictoryUI()
		
