extends TextureButton

const BASIC_CELL_HEALTH_RESOURCE = preload("res://Resources/Creature Resources/Premade Resources/Player/Health Resources/basic_cell_health_resource.tres")
const BASIC_CELL_SCENE_RESOURCE = preload("res://Resources/Creature Resources/Premade Resources/Player/Scene Resources/basic_cell_scene_resource.tres")

@export var player_creature_data: Creature_Resource
@export var player_inventory: PlayerInventory

@export var craft_cost: HBoxContainer

@export var player_resources_changed: Event

func _check_if_adjacent_cell(original_cell_position: Vector2, checked_cell_position: Vector2) -> bool:
	if int(original_cell_position.x) & 1: # if odd
		if abs(original_cell_position.x - checked_cell_position.x) == 1: # if the difference in the x values is 1
			if checked_cell_position.y - original_cell_position.y == 1 or checked_cell_position.y - original_cell_position.y == 0: # if the y values are the same or the checked y value is 1 greater
				return true
		elif original_cell_position.x == checked_cell_position.x: # else if the x values are the same
			if -1 <= checked_cell_position.y - original_cell_position.y and checked_cell_position.y - original_cell_position.y <= 1: # if the difference between the y values is between -1 and 1
				return true
	else: # if even
		if abs(original_cell_position.x - checked_cell_position.x) == 1: # if the difference in the x values is 1
			if checked_cell_position.y - original_cell_position.y == -1 or checked_cell_position.y - original_cell_position.y == 0: # if the y values are the same or the checked y value is 1 less
				return true
		elif original_cell_position.x == checked_cell_position.x: # else if the x values are the same
			if -1 <= checked_cell_position.y - original_cell_position.y and checked_cell_position.y - original_cell_position.y <= 1: # if the difference between the y values is between -1 and 1
				return true 
	return false

func check_if_enough_materials(craft_cost_dict: Dictionary) -> bool:
	for craft_cost in craft_cost_dict.keys():
		var craft_amount = craft_cost_dict[craft_cost]
		if craft_amount == 0:
			continue
		match craft_cost:
			"Gold":
				if player_inventory.gold < craft_amount:
					return false
			"Claws":
				if player_inventory.claws < craft_amount:
					return false
			"Hoofs":
				if player_inventory.hoofs < craft_amount:
					return false
			"Scales":
				if player_inventory.scales < craft_amount:
					return false
			"Shards":
				if player_inventory.shards < craft_amount:
					return false
			"Essence":
				if player_inventory.essence < craft_amount:
					return false
			"Keys":
				if player_inventory.keys < craft_amount:
					return false
			_:
				print_debug("invalid craft cost key")
				return false
	return true

func decrease_materials(craft_cost_dict: Dictionary):
	for craft_cost in craft_cost_dict.keys():
		var craft_amount = craft_cost_dict[craft_cost]
		if craft_amount == 0:
			continue
		match craft_cost:
			"Gold":
				player_inventory.gold -= craft_amount
			"Claws":
				player_inventory.claws -= craft_amount
			"Hoofs":
				player_inventory.hoofs -= craft_amount
			"Scales":
				player_inventory.scales -= craft_amount
			"Shards":
				player_inventory.shards -= craft_amount
			"Essence":
				player_inventory.essence -= craft_amount
			"Keys":
				player_inventory.keys -= craft_amount

func _on_pressed():
	
	#check to see if player has enough resources
	var craft_cost_dict = craft_cost.craft_cost_dict
	
	if check_if_enough_materials(craft_cost_dict) == false:
		return
	decrease_materials(craft_cost_dict)
	player_resources_changed.emit_signal("event_triggered")
	
	
	#Edit player creature data -- add in new cell
	var new_cell = Cell_Resource.new()
	var properties = Globals.active_cell_blueprint.get_node("Components/Properties")
	
	var adjacent_cell_array: Array[Cell_Resource] = []
	for cell in player_creature_data.creature_data_array:
		if _check_if_adjacent_cell(properties.position, cell.position) == true:
			adjacent_cell_array.append(cell)
			cell.adjacent_cell_array.append(new_cell)
	
	new_cell.Name = "basic"
	new_cell.position = properties.position
	new_cell.weight = 0
	new_cell.adjacent_cell_array = adjacent_cell_array
	new_cell.health_resource = BASIC_CELL_HEALTH_RESOURCE
	new_cell.scene_resource = BASIC_CELL_SCENE_RESOURCE
	player_creature_data.creature_data_array.append(new_cell)
	
	get_tree().current_scene.display_manager.globalDisplayCreatureData()
	
	Globals.active_cell_blueprint.get_node("Components").get_node("MouseInputComponent").globalDeselectBlueprint()
	Globals.active_cell_blueprint = null
