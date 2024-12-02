extends Node

@export var Enemies: Array[EnemyDrop]

@export var num_of_enemies: int
@export var victory_ui: Control

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
	if PlayerResources.pkey > randnum:
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
					PlayerResources.globalIncreaseGold(1)
				"Claw":
					PlayerResources.globalIncreaseClaws(1)
				"Hoof":
					PlayerResources.globalIncreaseHoofs(1)
				"Scale":
					PlayerResources.globalIncreaseScales(1)
				"Shard":
					PlayerResources.globalIncreaseShards(1)
				"Essence":
					PlayerResources.globalIncreaseEssence(1)
				_:
					print_debug("invalid resource gained?!?")
			
			resources_gained[resource_type] += 1
	
	if _get_key():
		PlayerResources.globalIncreaseKeys(1)
		PlayerResources.pkey = 0
		resources_gained["Key"] = 1
	else:
		PlayerResources.pkey += 25
	
	return resources_gained

func onEnemyDeath(_event_data):
	num_of_enemies -= 1
	if num_of_enemies == 0:
		var resources_gained = _calculate_and_increase_resources()
		victory_ui.resources_gained = resources_gained
		victory_ui.globalShowVictoryUI()
		EventManager.unsubscribe("EnemyDefeated", onEnemyDeath)
