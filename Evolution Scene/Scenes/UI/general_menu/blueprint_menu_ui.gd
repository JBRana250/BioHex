extends Node

const creature_part_blueprint_panel_scene = preload("res://Evolution Scene/Scenes/UI/general_menu/blueprint_panel/creature_part_blueprint_panel.tscn")

@export var initial_creature_part_ui_database: CreaturePartUIDatabase

@export var display_vbox: VBoxContainer

@export var creature_part_type: String
var current_cell_position: Vector2
var current_part_position: int

class CraftCost:
	var mat_amount: int
	var mat_type: String
	func _init(_mat_amount: int, _mat_type: String):
		mat_amount = _mat_amount
		mat_type = _mat_type

func clear_display():
	for child in display_vbox.get_children():
		child.queue_free()

func display_parts(creature_part_ui_database: CreaturePartUIDatabase = initial_creature_part_ui_database):
	clear_display()
	
	for part in creature_part_ui_database.creature_parts:
		var creature_part_blueprint_panel_instance = creature_part_blueprint_panel_scene.instantiate()
		creature_part_blueprint_panel_instance.creature_part_name = part.creature_part_name
		creature_part_blueprint_panel_instance.creature_part_description = part.creature_part_description
		creature_part_blueprint_panel_instance.creature_part_resource = part.creature_part_resource
		creature_part_blueprint_panel_instance.creature_part_position = current_part_position
		creature_part_blueprint_panel_instance.current_cell_position = current_cell_position
		creature_part_blueprint_panel_instance.creature_part_type = creature_part_type
		
		var craft_cost_array: Array[CraftCost] = []
		
		for craft_cost_key in part.creature_part_craft_cost.keys():
			if part.creature_part_craft_cost[craft_cost_key] > 0:
				craft_cost_array.append(CraftCost.new(part.creature_part_craft_cost[craft_cost_key], craft_cost_key))
		
		creature_part_blueprint_panel_instance.craft_cost_array = craft_cost_array
		creature_part_blueprint_panel_instance.initialize_creature_part_blueprint()
		display_vbox.add_child(creature_part_blueprint_panel_instance)
	
