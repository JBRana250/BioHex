extends TextureButton

const BASIC_CELL_HEALTH_RESOURCE = preload("res://Resources/Creature Resources/Premade Resources/Player/Health Resources/basic_cell_health_resource.tres")
const BASIC_CELL_SCENE_RESOURCE = preload("res://Resources/Creature Resources/Premade Resources/Player/Scene Resources/basic_cell_scene_resource.tres")

@export var player_creature_data: Creature_Resource

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

func _on_pressed():
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
