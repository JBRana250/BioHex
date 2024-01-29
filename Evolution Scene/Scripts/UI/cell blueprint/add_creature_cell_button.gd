extends TextureButton

const BASIC_CELL_HEALTH_RESOURCE = preload("res://Resources/Creature Resources/Premade Resources/Player/Health Resources/basic_cell_health_resource.tres")
const BASIC_CELL_SCENE_RESOURCE = preload("res://Resources/Creature Resources/Premade Resources/Player/Scene Resources/basic_cell_scene_resource.tres")

func _on_pressed():
	
	#Edit player creature data -- add in new cell
	var new_cell = Cell_Resource.new()
	var properties = Globals.active_cell_blueprint.get_node("Components/Properties")
	new_cell.Name = "basic"
	new_cell.position = properties.position
	new_cell.weight = 0
	new_cell.health_resource = BASIC_CELL_HEALTH_RESOURCE
	new_cell.scene_resource = BASIC_CELL_SCENE_RESOURCE
	Globals.player_creature_data.creature_data_array.append(new_cell)
	
	get_tree().current_scene.get_node("Interface/Components/DisplayCreatureData").globalDisplayCreatureData()
	
	Globals.active_cell_blueprint.get_node("Components").get_node("MouseInputComponent").globalDeselectBlueprint()
	Globals.active_cell_blueprint = null
