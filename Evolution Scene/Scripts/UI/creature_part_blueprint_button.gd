extends Node

@export var player_resources_changed: Event

@export var player_creature_data: Creature_Resource
@export var player_inventory: PlayerInventory
var creature_part_type: String
var creature_part_resource: Resource
var creature_part_position: int
var current_cell_position: Vector2

var craft_cost_array: Array

var current_cell: Cell_Resource

@export var evo_ui_mouse_filter_change: EventWithParam

func display_changes():
	evo_ui_mouse_filter_change.event_triggered.emit("pass")
	get_tree().current_scene.display_manager.globalDisplayCreatureData()
	Globals.active_cell_blueprint.get_node("Components").get_node("MouseInputComponent").globalDeselectBlueprint()
	Globals.active_cell_blueprint = null

func _get_pos_to_origin(cell_pos: Vector2, part_position: int) -> Vector2:
	match int(cell_pos.x) & 1:
		1: # Odd
			match part_position:
				1:
					return Vector2(cell_pos.x, cell_pos.y - 1)
				2:
					return Vector2(cell_pos.x - 1, cell_pos.y)
				3:
					return Vector2(cell_pos.x - 1, cell_pos.y + 1)
				4:
					return Vector2(cell_pos.x, cell_pos.y + 1)
				5:
					return Vector2(cell_pos.x + 1, cell_pos.y + 1)
				6:
					return Vector2(cell_pos.x + 1, cell_pos.y)
				_:
					print_debug("unknown part position '%s'" % part_position)
					return Vector2(0,0)
		0:
			match part_position:
				1:
					return Vector2(cell_pos.x, cell_pos.y - 1)
				2:
					return Vector2(cell_pos.x - 1, cell_pos.y - 1)
				3:
					return Vector2(cell_pos.x - 1, cell_pos.y)
				4:
					return Vector2(cell_pos.x, cell_pos.y + 1)
				5:
					return Vector2(cell_pos.x + 1, cell_pos.y)
				6:
					return Vector2(cell_pos.x + 1, cell_pos.y - 1)
				_:
					print_debug("unknown part position '%s'" % part_position)
					return Vector2(0,0)
	
	
	return Vector2()

func craft_core_part():
	var new_core_part_resource = Core_Creature_Part_Resource.new()
	new_core_part_resource.Name = creature_part_resource.Name
	new_core_part_resource.type = creature_part_resource.type
	new_core_part_resource.core = creature_part_resource.core
	
	new_core_part_resource.rel_pos_to_cell_resource = creature_part_resource.rel_pos_to_cell_resource
	
	new_core_part_resource.health_resource = creature_part_resource.health_resource
	new_core_part_resource.scene_resource = creature_part_resource.scene_resource
	new_core_part_resource.damage_resource = creature_part_resource.damage_resource
	
	current_cell.core_creature_part = new_core_part_resource
	display_changes()

func craft_outer_part():
	var new_outer_part_resource = Outer_Creature_Part_Resource.new()

	new_outer_part_resource.Name = creature_part_resource.Name
	new_outer_part_resource.type = creature_part_resource.type
	
	new_outer_part_resource.position = creature_part_position
	
	var pos_to_origin = _get_pos_to_origin(current_cell_position, creature_part_position)
	
	new_outer_part_resource.pos_to_origin = pos_to_origin
	
	new_outer_part_resource.rel_pos_to_cell_resource = creature_part_resource.rel_pos_to_cell_resource
	
	new_outer_part_resource.health_resource = creature_part_resource.health_resource
	new_outer_part_resource.scene_resource = creature_part_resource.scene_resource
	new_outer_part_resource.damage_resource = creature_part_resource.damage_resource
	
	current_cell.outer_creature_parts.append(new_outer_part_resource)
	
	display_changes()

func craft_inner_part():
	var new_inner_part_resource = Inner_Creature_Part_Resource.new()
	
	new_inner_part_resource.Name = creature_part_resource.Name
	new_inner_part_resource.type = creature_part_resource.type
	
	new_inner_part_resource.position = creature_part_position
	var pos_to_origin = _get_pos_to_origin(current_cell_position, creature_part_position)
	new_inner_part_resource.pos_to_origin = pos_to_origin
	
	new_inner_part_resource.rel_pos_to_cell_resource = creature_part_resource.rel_pos_to_cell_resource
	
	new_inner_part_resource.health_resource = creature_part_resource.health_resource
	new_inner_part_resource.scene_resource = creature_part_resource.scene_resource
	new_inner_part_resource.damage_resource = creature_part_resource.damage_resource
	
	current_cell.outer_creature_parts.append(new_inner_part_resource)
	display_changes()

func _check_resources() -> bool:
	for craft_cost in craft_cost_array:
		match craft_cost.mat_type:
			"Claws":
				if player_inventory.claws < craft_cost.mat_amount:
					return false
			"Hoofs":
				if player_inventory.hoofs < craft_cost.mat_amount:
					return false
			"Scales":
				if player_inventory.scales < craft_cost.mat_amount:
					return false
			"Shards":
				if player_inventory.shards < craft_cost.mat_amount:
					return false
			"Essence":
				if player_inventory.essence < craft_cost.mat_amount:
					return false
			_:
				print_debug("unknown mat type %s" % craft_cost.mat_type)
	return true

func _decrease_resources():
	for craft_cost in craft_cost_array:
		match craft_cost.mat_type:
			"Claws":
				player_inventory.claws -= craft_cost.mat_amount
			"Hoofs":
				player_inventory.hoofs -= craft_cost.mat_amount
			"Scales":
				player_inventory.scales -= craft_cost.mat_amount
			"Shards":
				player_inventory.shards -= craft_cost.mat_amount
			"Essence":
				player_inventory.essence -= craft_cost.mat_amount
			_:
				print_debug("unknown mat type %s" % craft_cost.mat_type)
	player_resources_changed.emit_signal("event_triggered")

func _on_pressed() -> void:
	current_cell_position = owner.current_cell_position
	creature_part_type = owner.creature_part_type # core, outer or inner.
	creature_part_position = owner.creature_part_position
	creature_part_resource = owner.creature_part_resource
	craft_cost_array = owner.craft_cost_array
	 
	# get current cell
	for cell in player_creature_data.creature_data_array:
		if cell.position == current_cell_position:
			current_cell = cell
	
	if _check_resources() == false:
		return
	_decrease_resources()
	
	match creature_part_type:
		"core":
			craft_core_part()
		"inner":
			craft_inner_part()
		"outer":
			craft_outer_part()
