extends Node

@export var item_db: ItemDatabase

func _get_item():
	
	var rarity_one_weight = len(item_db.rarity_one_items)
	var rarity_two_weight = len(item_db.rarity_two_items)
	var rarity_three_weight = len(item_db.rarity_three_items)
	var rarity_four_weight = len(item_db.rarity_four_items)
	var rarity_five_weight = len(item_db.rarity_five_items)
	
	var weights = {
		rarity_one_weight: 1,
		rarity_two_weight: 2,
		rarity_three_weight: 3,
		rarity_four_weight: 4, 
		rarity_five_weight: 5
		}
	
	var total_item_weight = rarity_one_weight + (2 * rarity_two_weight) + (3 * rarity_three_weight) + (4 * rarity_four_weight) + (5 * rarity_five_weight)
	
	var randnum = randi_range(0, total_item_weight)
	var accumulated_weight = 0
	
	for weight in weights.keys():
		if accumulated_weight <= randnum or randnum <= accumulated_weight + weight:
			return _get_item_of_rarity(weights[weight])
		accumulated_weight += weight
	
	print_debug("error, item rarity cannot be decided")
	return null

func _get_item_of_rarity(_rarity: int):
	match _rarity:
		1:
			var item = item_db.rarity_one_items[randi_range(0, len(item_db.rarity_one_items) - 1)]
			return item
		2:
			var item = item_db.rarity_two_items[randi_range(0, len(item_db.rarity_two_items) - 1)]
			return item
		3:
			var item = item_db.rarity_three_items[randi_range(0, len(item_db.rarity_three_items) - 1)]
			return item
		4:
			var item = item_db.rarity_four_items[randi_range(0, len(item_db.rarity_four_items) - 1)]
			return item
		5:
			var item = item_db.rarity_five_items[randi_range(0, len(item_db.rarity_five_items) - 1)]
			return item

func _get_item_without_replacement():
	var rarity_one_weight = len(item_db.rarity_one_items)
	var rarity_two_weight = 2 * len(item_db.rarity_two_items)
	var rarity_three_weight = 3 * len(item_db.rarity_three_items)
	var rarity_four_weight = 4 * len(item_db.rarity_four_items)
	var rarity_five_weight = 5 * len(item_db.rarity_five_items)
	
	var weights = {
		rarity_one_weight: 1,
		rarity_two_weight: 2,
		rarity_three_weight: 3,
		rarity_four_weight: 4, 
		rarity_five_weight: 5
		}
	
	var total_item_weight = rarity_one_weight + rarity_two_weight + rarity_three_weight + rarity_four_weight + rarity_five_weight
	
	var randnum = randi_range(0, total_item_weight)
	var accumulated_weight = 0
	
	for weight in weights.keys():
		if accumulated_weight <= randnum and randnum <= accumulated_weight + weight:
			return _get_item_without_replacement_of_rarity(weights[weight])
		accumulated_weight += weight
		
	return _get_item_without_replacement_of_rarity(weights[rarity_four_weight]) # change to 5 later

func _get_item_without_replacement_of_rarity(_rarity: int):
	match _rarity:
		1:
			var item = item_db.rarity_one_items[randi_range(0, len(item_db.rarity_one_items) - 1)]
			item_db.rarity_one_items.erase(item)
			return item
		2:
			var item = item_db.rarity_two_items[randi_range(0, len(item_db.rarity_two_items) - 1)]
			item_db.rarity_two_items.erase(item)
			return item
		3:
			var item = item_db.rarity_three_items[randi_range(0, len(item_db.rarity_three_items) - 1)]
			item_db.rarity_three_items.erase(item)
			return item
		4:
			var item = item_db.rarity_four_items[randi_range(0, len(item_db.rarity_four_items) - 1)]
			item_db.rarity_four_items.erase(item)
			return item
		5:
			var item = item_db.rarity_five_items[randi_range(0, len(item_db.rarity_five_items) - 1)]
			item_db.rarity_five_items.erase(item)
			return item
