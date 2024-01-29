extends Node

@onready var creature_resource = Globals.player_creature_data
@onready var body = creature_resource.body

@onready var interface = get_parent().get_parent()

const basic_cell_blueprint = preload("res://Evolution Scene/Scenes/Cell Part Blueprints/cell blueprint/basiccellblueprint.tscn")
const CELL_BLUEPRINTS = preload("res://Evolution Scene/Scenes/CellBlueprints.tscn")


var body_instance: Node3D
var cell_blueprints_instance: Node3D

var possible_cell_blueprint_positions = []

class CellBlueprintData:
	var pre_check_position
	var position
	
	#region Checking For Directly Opposing Position Numbers
	func _get_directly_opposing_number(number: int):
		match number:
			1:
				return 4
			2:
				return 5
			3:
				return 6
			4:
				return 1
			5:
				return 2
			6:
				return 3

	func _check_directly_opposing_numbers(cell_position_array):
		var directly_opposing_numbers = []
		var duplicate_position_array = cell_position_array.duplicate()
		for num in cell_position_array:
			directly_opposing_numbers.append(_get_directly_opposing_number(num))
		for number in cell_position_array:
			if number in directly_opposing_numbers:
				directly_opposing_numbers.erase(number)
				directly_opposing_numbers.erase(_get_directly_opposing_number(number))
				duplicate_position_array.erase(number)
				duplicate_position_array.erase(_get_directly_opposing_number(number))
		return duplicate_position_array
	#endregion
	
	#region Checking For Composite Numbers (two position numbers that can simplify into a single position number)

	# A class, that upon initialization (with passing in the current number only), can calculate what the two trigger numbers needed are and accordingly what the resultant numbers are.
	class PossibleCompositeData:
		
		#The number that this object is representing
		var current_number: int
		
		#The two numbers that can cause a composite to be created
		var trigger_number_x: int
		var trigger_number_y: int
		
		#The two numbers that can result from the composite
		var resultant_number_x: int
		var resultant_number_y: int
		
		#Keys are the composition of numbers, values are the resultant simplified position number. This array will be used to calculate the trigger and resultant numbers.
		var composite_position_numbers = {[2,6]:1, [3,5]:4, [1,3]:2, [1,5]:6, [4,2]:3, [4,6]:5}
		
		func _get_matching_entries(_number: int) -> Dictionary:
			var matching_entries = {}
			for key in composite_position_numbers.keys():
				if _number in key:
					matching_entries[key] = composite_position_numbers[key]
			return matching_entries
		
		#Returns an array containing two V2s. The x will represent trigger number, y represent the resultant number
		func _get_matching_composite_data(_number: int) -> Array[Vector2]: 
			var matching_composite_data: Array[Vector2] = []
			var matching_entries = _get_matching_entries(_number)
			for entry_key in matching_entries.keys():
				for number in entry_key:
					if number != _number:
						matching_composite_data.append(Vector2(number,composite_position_numbers[entry_key]))
			return matching_composite_data

		func _init(_current_number):
			current_number = _current_number
			var matching_composite_data = _get_matching_composite_data(_current_number)
			var composite_data_x = matching_composite_data[0]
			var composite_data_y = matching_composite_data[1]
			trigger_number_x = composite_data_x.x
			resultant_number_x = composite_data_x.y
			trigger_number_y = composite_data_y.x
			resultant_number_y = composite_data_y.y

	func _erase_matching_composite_data(possible_composite_data_array: Array[PossibleCompositeData], number: int):
		for possible_composite_data in possible_composite_data_array:
			if possible_composite_data.current_number == number:
				possible_composite_data_array.erase(possible_composite_data)
		return possible_composite_data_array

	func _check_composite_positions(cell_position_array: Array) -> Array:
		var possible_composite_data_array: Array[PossibleCompositeData] = []
		var dupe_cell_position_array: Array = cell_position_array.duplicate()
		var reaction_triggered: bool
		reaction_triggered = false
		for num in cell_position_array:
			possible_composite_data_array.append(PossibleCompositeData.new(num))
		for position_number in cell_position_array:
			if reaction_triggered:
				break
			for possible_composite_data in possible_composite_data_array:
				if reaction_triggered:
					break
				if position_number == possible_composite_data.trigger_number_x and !reaction_triggered:
					dupe_cell_position_array.erase(possible_composite_data.current_number)
					dupe_cell_position_array.erase(possible_composite_data.trigger_number_x)
					dupe_cell_position_array.append(possible_composite_data.resultant_number_x)
					reaction_triggered = true
				if position_number == possible_composite_data.trigger_number_y and !reaction_triggered:
					dupe_cell_position_array.erase(possible_composite_data.current_number)
					dupe_cell_position_array.erase(possible_composite_data.trigger_number_y)
					dupe_cell_position_array.append(possible_composite_data.resultant_number_y)
					reaction_triggered = true
		if reaction_triggered:
			return _check_composite_positions(dupe_cell_position_array)
		return dupe_cell_position_array
	#endregion

	func _init(_pre_check_position):
		pre_check_position = _pre_check_position
		position = _check_directly_opposing_numbers(pre_check_position)
		position = _check_composite_positions(position)

var current_cell_blueprints: Array[CellBlueprintData] = []

func _spawn_thing(_thing, _parent, _position, _rotation):
	if !_thing:
		print_debug("thing that is trying to be spawned does not exist")
		return
	var thing_instance = _thing.instantiate()
	#if thing_instance.get_class() == "Node" or thing_instance.get_class() == "Timer":
		#_parent.add_child(thing_instance)
		#return thing_instance
	_parent.add_child(thing_instance)
	thing_instance.position = _position
	thing_instance.rotation = _rotation
	return thing_instance

func _append_possible_cell_blueprint_positions(cell_position):
	var cell_position_array_clone = cell_position.duplicate()
	for number in [1,2,3,4,5,6]:
		cell_position_array_clone.append(number)
		var newCellBlueprintData = CellBlueprintData.new(cell_position_array_clone) #When this object is initialized, it will automatically check for directly opposing and composite.
		current_cell_blueprints.append(newCellBlueprintData)
		possible_cell_blueprint_positions.append(newCellBlueprintData.position)
		cell_position_array_clone = cell_position.duplicate()

func _display_creature():
	# Instantiate body
	body_instance = _spawn_thing(body, interface, Vector3(), Vector3())
	var ranged_weapons = body_instance.get_node("RangedWeapons")
	var melee_weapons = body_instance.get_node("MeleeWeapons")

	# Iterate over creature_data, for each cell in creature data, instantiate it according to position.
	for cell in creature_resource.creature_data_array:
		# Figure out position
		_append_possible_cell_blueprint_positions(cell.position)
		var cell_pos = Vector3()
		for number in cell.position:
			match number:
				1:
					cell_pos.z += 1.7
				2:
					cell_pos.x += -1.5
					cell_pos.z += 0.85
				3:
					cell_pos.x += -1.5
					cell_pos.z += -0.85
				4:
					cell_pos.z += -1.7
				5:
					cell_pos.x += 1.5
					cell_pos.z += -0.85
				6:
					cell_pos.x += 1.5
					cell_pos.z += 0.85
		var scene_resource = cell.scene_resource
		var _cell_instance = _spawn_thing(scene_resource.scene, body_instance, cell_pos, Vector3())
		
		#Instantiate core component of cell (if any)
		var core_component = cell.core_component
		if core_component:
			match core_component.type:
				"ranged_weapon":
					# Will have to create an array with the relative position vectors for the other core components.
					# For now, just use a single temporary V3
					var temp_position_vector = Vector3(cell_pos.x, 1, cell_pos.z)
					scene_resource = core_component.scene_resource
					var _core_component_instance = _spawn_thing(scene_resource.scene, ranged_weapons, temp_position_vector, Vector3())
					
		for inner_component in cell.inner_components:
			pass
			#no inner components for now
			
		for outer_component in cell.outer_components:
			var outer_component_pos = cell_pos
			var outer_component_rotation = Vector3()
			match outer_component.type:
				"melee_weapon":
					match outer_component.position:
						1:
							outer_component_pos.z += 1.1
							outer_component_rotation = Vector3()
						2:
							outer_component_pos.x += -0.93 
							outer_component_pos.z += 0.54
							outer_component_rotation = Vector3(0, deg_to_rad(300), 0)
						3:
							outer_component_pos.x += -0.93 
							outer_component_pos.z += -0.54
							outer_component_rotation = Vector3(0, deg_to_rad(240), 0)
						4:
							outer_component_pos.z += -1.1
							outer_component_rotation = Vector3(0, deg_to_rad(180), 0)
						5:
							outer_component_pos.x += 0.93 
							outer_component_pos.z += -0.54
							outer_component_rotation = Vector3(0, deg_to_rad(120), 0)
						6:
							outer_component_pos.x += 0.93 
							outer_component_pos.z += 0.54
							outer_component_rotation = Vector3(0, deg_to_rad(60), 0)
					scene_resource = outer_component.scene_resource
					var _outer_component_instance = _spawn_thing(scene_resource.scene, melee_weapons, outer_component_pos, outer_component_rotation)

func _check_if_position_in_array(position):
	for i in range(possible_cell_blueprint_positions.size()-1, -1, -1):
		if possible_cell_blueprint_positions[i] == position:
			possible_cell_blueprint_positions.remove_at(i)

func _display_cell_blueprints():
	for cell in creature_resource.creature_data_array:
		_check_if_position_in_array(cell.position)
		for outer_component in cell.outer_components:
			var outer_component_position_array = cell.position.duplicate()
			outer_component_position_array.append(outer_component.position)
			_check_if_position_in_array(outer_component_position_array)
	
	var positions_already_in_array = []
	for i in range(possible_cell_blueprint_positions.size()-1,-1,-1):
		if possible_cell_blueprint_positions[i] in positions_already_in_array:
			possible_cell_blueprint_positions.remove_at(i)
		else:
			positions_already_in_array.append(possible_cell_blueprint_positions[i])
			
	#Instantiate "Cell Blueprints" Node3D. All cell blueprints will be a child of this node.
	cell_blueprints_instance = _spawn_thing(CELL_BLUEPRINTS, interface, Vector3(), Vector3())
	
	
	for position in possible_cell_blueprint_positions:
		var blueprint_pos = Vector3()
		for num in position:
			match num:
				1:
					blueprint_pos.z += 1.7
				2:
					blueprint_pos.x += -1.5
					blueprint_pos.z += 0.85
				3:
					blueprint_pos.x += -1.5
					blueprint_pos.z += -0.85
				4:
					blueprint_pos.z += -1.7
				5:
					blueprint_pos.x += 1.5
					blueprint_pos.z += -0.85
				6:
					blueprint_pos.x += 1.5
					blueprint_pos.z += 0.85
		var cell_blueprint_instance = _spawn_thing(basic_cell_blueprint, cell_blueprints_instance, blueprint_pos, Vector3())
		cell_blueprint_instance.get_node("Components/Properties").position = position

func globalDisplayCreatureData():
	current_cell_blueprints.clear()
	if is_instance_valid(body_instance):
		body_instance.queue_free()
	if is_instance_valid(cell_blueprints_instance):
		cell_blueprints_instance.queue_free()
	_display_creature()
	_display_cell_blueprints()
	
func _ready():
	call_deferred("globalDisplayCreatureData")
