extends Button

const opened_treasure = preload("res://World Scene/assets/biohex chest unlocked.png")
const resource_gained_ui = preload("res://Combat Scene/scenes/ResourceGained.tscn")
@export var under_treasure: HFlowContainer
@export var num_of_drops: int
@export var opened: bool = false

@export var common_drops: int
@export var rare_drops: int
@export var legendary_drops: int

@export var weights: Dictionary = {
	"Gold": 5,
	"Claw": 1,
	"Hoof": 1,
	"Scale": 1,
	"Shard": 1,
	"Essence": 1
}

func _get_rand_resource():
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
	
	match owner.keys_needed:
		1:
			num_of_drops = common_drops
		2:
			num_of_drops = rare_drops
		3:
			num_of_drops = legendary_drops
			
	for i in range(num_of_drops):
		var resource_type = _get_rand_resource()
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
	
	return resources_gained

func _on_pressed() -> void:
	if PlayerResources.keys < owner.keys_needed:
		return
	if opened:
		return
		
	PlayerResources.keys -= owner.keys_needed
	owner._assign_key_labels()
	icon = opened_treasure
	
	for child in under_treasure.get_children():
		child.queue_free()
	
	var resources_gained = _calculate_and_increase_resources()
	
	var amount_gained = 0
	
	for resource in resources_gained.keys():
		amount_gained = resources_gained[resource]
		if amount_gained != 0:
			var resgained_instance = resource_gained_ui.instantiate()
			under_treasure.add_child(resgained_instance)
			resgained_instance.amount_gained = amount_gained
			resgained_instance.resource_gained = resource
			resgained_instance.globalShowResourcesGained()
	opened = true
