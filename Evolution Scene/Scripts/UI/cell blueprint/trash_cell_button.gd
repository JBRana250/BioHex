extends TextureButton

@export var cell_properties: Node
@export var player_creature_data: Creature_Resource

@export var warning_message_label: Label

## Information ----

func _check_if_connected_cell(cell: Cell_Resource, already_investigated_cells_array: Array[Cell_Resource]) -> bool:
	
	if cell.position == Vector2(0,0):
		return true
	
	already_investigated_cells_array.append(cell)
	
	for adjacent_cell in cell.adjacent_cell_array:
		if adjacent_cell in already_investigated_cells_array:
			continue
		
		return _check_if_connected_cell(adjacent_cell, already_investigated_cells_array)
	
	return false

## --------------

func _on_pressed(): 
	
	var invalid_trash: bool = false
	
	var current_cell: Cell_Resource
	
	# find cell through cell pos
	for cell in player_creature_data.creature_data_array:
		if cell.position == cell_properties.cell_pos:
			current_cell = cell
			player_creature_data.creature_data_array.erase(cell)
	
	for adjacant_cell in current_cell.adjacent_cell_array:
		adjacant_cell.adjacent_cell_array.erase(current_cell)
		if _check_if_connected_cell(adjacant_cell, []) == false:
			invalid_trash = true
	
	if invalid_trash:
		for adjacent_cell in current_cell.adjacent_cell_array:
			adjacent_cell.adjacent_cell_array.append(current_cell)
		player_creature_data.creature_data_array.append(current_cell)
		warning_message_label.visible = true
	else:
		get_tree().current_scene.display_manager.globalDisplayCreatureData()
		Globals.active_cell_blueprint.get_node("Components").get_node("MouseInputComponent").globalDeselectBlueprint()
		Globals.active_cell_blueprint = null
