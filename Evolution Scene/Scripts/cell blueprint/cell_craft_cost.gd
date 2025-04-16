extends Node

@onready var craft_cost_module = preload("res://Evolution Scene/Scenes/UI/general_menu/craft_cost/blueprint_craft_cost.tscn")

@export var player_creature_data: Creature_Resource
var craft_cost_dict: Dictionary

func get_craft_cost(num_of_cells: float) -> Dictionary:
	
	var num_of_scales: float = ceil(num_of_cells / 2)
	
	return {
		"Gold": 0,
		"Claws": 0,
		"Hoofs": 0,
		"Scales": num_of_scales,
		"Shards": 0,
		"Essence": 0,
		"Keys": 0
	}

func _ready():
	
	# get num of cells
	var num_of_cells: float = float(len(player_creature_data.creature_data_array))
	
	# get craft cost
	craft_cost_dict = get_craft_cost(num_of_cells)
	
	# display craft cost
	for craft_cost in craft_cost_dict.keys():
		var mat_amount = craft_cost_dict[craft_cost]
		if mat_amount == 0:
			continue
		
		var craft_cost_module_instance = craft_cost_module.instantiate()
		craft_cost_module_instance.mat_amount = mat_amount
		craft_cost_module_instance.material_type = craft_cost
		
		craft_cost_module_instance.display_craft_cost()
		
		self.add_child(craft_cost_module_instance)
