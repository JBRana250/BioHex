extends Node

const craft_cost_scene = preload("res://Evolution Scene/Scenes/UI/general_menu/craft_cost/creature_part_blueprint_craft_cost.tscn")

@export var creature_part_name_label: Label
@export var creature_part_description_label: Label
@export var craft_cost_hbox: HBoxContainer

var creature_part_name: String
var creature_part_description: String
var craft_cost_array: Array

var creature_part_type: String # core, outer or inner.
var creature_part_position: int
var creature_part_resource: Creature_Part_Resource
var current_cell_position: Vector2

func initialize_creature_part_blueprint():
	creature_part_name_label.text = creature_part_name
	creature_part_description_label.text = creature_part_description
	
	for craft_cost in craft_cost_array:
		var craft_cost_instance = craft_cost_scene.instantiate()
		craft_cost_instance.mat_amount = craft_cost.mat_amount
		craft_cost_instance.material_type = craft_cost.mat_type
		craft_cost_instance.display_craft_cost()
		craft_cost_hbox.add_child(craft_cost_instance)
