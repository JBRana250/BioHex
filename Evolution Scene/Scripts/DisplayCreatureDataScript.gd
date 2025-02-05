extends Node

@onready var creature_resource = Globals.player_creature_data
@onready var body = creature_resource.body

@onready var interface = get_parent().get_parent()

const BASIC_CELL_BLUEPRINT = preload("res://Evolution Scene/Scenes/Cell Part Blueprints/cell blueprint/cell_blueprint.tscn")
const CELL_BLUEPRINTS = preload("res://Evolution Scene/Scenes/CellBlueprints.tscn")

const CELL_EDITOR_AREA = preload("res://Evolution Scene/Scenes/celleditorarea.tscn")
const CELL_EDITORS = preload("res://Evolution Scene/Scenes/CellEditors.tscn")

const CORE_BLUEPRINT = preload("res://Evolution Scene/Scenes/Cell Part Blueprints/cell blueprint/core_creature_part_blueprint.tscn")
const OUTER_BLUEPRINT = preload("res://Evolution Scene/Scenes/Cell Part Blueprints/cell blueprint/outer_creature_part_blueprint.tscn")

var body_instance: Node3D

var cell_blueprints_collection_instance: Node3D
var cell_editors_collection_instance: Node3D

## Information Class ##

class CellData:
	var position: Vector2
	var cell: Node3D
	var core_creature_part: bool = false
	var outer_creature_parts_positions: Array[int] = []
	var parent_cells: Array
	func _init(_position, _cell, _has_core_creature_part, _outer_creature_parts_positions, _parent_cells):
		position = _position
		cell = _cell
		core_creature_part = _has_core_creature_part
		outer_creature_parts_positions = _outer_creature_parts_positions
		parent_cells = _parent_cells

#Array contained the data for existing cells
var ExistingCellDataArray: Array[CellData] = []

## Get Information ##

func _check_if_connected_cell(cell_data: CellData) -> bool:
	for parent_cell in cell_data.parent_cells:
		if parent_cell.position == Vector2(0,0):
			return true
		else:
			_check_if_connected_cell(parent_cell)
	return false

func _get_number_sign(number):
	if number > 0:
		return "POS"
	if number < 0:
		return "NEG"
	if number == 0:
		return "ZERO"
	else:
		print_debug("error getting sign")
		return "ERR"

func _unpack_cell_position(cell_pos: Vector2) -> Vector3:
	var unpacked_y_position = cell_pos.y * -1.7
	var unpacked_x_position: float = 0
	var step: float
	if int(cell_pos.x) & 1: # if odd
		unpacked_y_position += -0.85
		match _get_number_sign(cell_pos.x):
			"POS":
				unpacked_x_position += 1.5
				step = ceil(cell_pos.x / 2)
				unpacked_x_position += (cell_pos.x - step) * 3
			"NEG":
				unpacked_x_position -= 1.5
				step = floor(cell_pos.x / 2)
				unpacked_x_position += (cell_pos.x - step) * 3
	else: # if even
		match _get_number_sign(cell_pos.x):
			"POS":
				step = cell_pos.x / 2
				unpacked_x_position = (cell_pos.x - step) * 3
			"NEG":
				step = cell_pos.x / 2
				unpacked_x_position = (cell_pos.x - step) * 3
	return Vector3(unpacked_x_position, 0, unpacked_y_position)

func _get_global_position_based_on_local_position(local_position: int, global_parent_position: Vector2) -> Vector2:
	var global_position = global_parent_position
	match local_position:
		1:
			global_position.y -= 1
		2:
			if int(global_position.x) & 1: # if odd:
				global_position.x -= 1
			else: # if even
				global_position.x -= 1
				global_position.y -= 1
		3:
			if int(global_position.x) & 1:
				global_position.x -= 1
				global_position.y += 1
			else:
				global_position.x -= 1
		4:
			global_position.y += 1
		5:
			if int(global_position.x) & 1:
				global_position.x += 1
				global_position.y += 1
			else:
				global_position.x += 1
		6:
			if int(global_position.x) & 1:
				global_position.x += 1
			else:
				global_position.x += 1
				global_position.y -= 1
	return global_position

func _get_component_rotation_based_on_local_position(local_position: int) -> Vector3:
	match local_position:
		1:
			return Vector3()
		2:
			return Vector3(0, deg_to_rad(300), 0)
		3:
			return Vector3(0, deg_to_rad(240), 0)
		4:
			return Vector3(0, deg_to_rad(180), 0)
		5:
			return Vector3(0, deg_to_rad(120), 0)
		6:
			return Vector3(0, deg_to_rad(60), 0)
		_:
			print_debug("invalid position: only 1 - 6 allowed. Position input: %s" % local_position)
			return Vector3()

## Spawning

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

func _display_creature():
	# Instantiate body
	body_instance = _spawn_thing(body, interface, Vector3(), Vector3())
	var ranged_weapons = body_instance.get_node("RangedWeapons")
	var melee_weapons = body_instance.get_node("MeleeWeapons")

	# Iterate over creature_data, for each cell in creature data, instantiate it according to position.
	for cell in creature_resource.creature_data_array:
		# Figure out position
		var cell_pos = _unpack_cell_position(cell.position)
		var scene_resource = cell.scene_resource
		var cell_instance = _spawn_thing(scene_resource.scene, body_instance, cell_pos, Vector3())
		
		#Instantiate core component of cell (if any)
		var core_creature_part = cell.core_creature_part
		
		var has_core_creature_part: bool = false
		var outer_creature_part_positions: Array[int] = []
		
		if core_creature_part:
			has_core_creature_part = true
			match core_creature_part.type:
				"ranged_weapon":
					# Will have to create an array with the relative position vectors for the other core components.
					# For now, just use a single temporary V3
					var temp_position_vector = Vector3(cell_pos.x, 1, cell_pos.z)
					scene_resource = core_creature_part.scene_resource
					var _core_creature_part_instance = _spawn_thing(scene_resource.scene, ranged_weapons, temp_position_vector, Vector3())
					
		for inner_creature_part in cell.inner_creature_parts:
			pass
			#no inner components for now
		
		for outer_creature_part in cell.outer_creature_parts:
			var outer_creature_part_pos = cell_pos
			var outer_creature_part_rotation = Vector3()
			outer_creature_part_positions.append(outer_creature_part.position)
			match outer_creature_part.type:
				"melee_weapon":
					match outer_creature_part.position:
						1:
							outer_creature_part_pos.z += 1.1
							outer_creature_part_rotation = Vector3()
						2:
							outer_creature_part_pos.x += -0.93 
							outer_creature_part_pos.z += 0.54
							outer_creature_part_rotation = Vector3(0, deg_to_rad(300), 0)
						3:
							outer_creature_part_pos.x += -0.93 
							outer_creature_part_pos.z += -0.54
							outer_creature_part_rotation = Vector3(0, deg_to_rad(240), 0)
						4:
							outer_creature_part_pos.z += -1.1
							outer_creature_part_rotation = Vector3(0, deg_to_rad(180), 0)
						5:
							outer_creature_part_pos.x += 0.93 
							outer_creature_part_pos.z += -0.54
							outer_creature_part_rotation = Vector3(0, deg_to_rad(120), 0)
						6:
							outer_creature_part_pos.x += 0.93 
							outer_creature_part_pos.z += 0.54
							outer_creature_part_rotation = Vector3(0, deg_to_rad(60), 0)
					scene_resource = outer_creature_part.scene_resource
					var _outer_creature_part_instance = _spawn_thing(scene_resource.scene, melee_weapons, outer_creature_part_pos, outer_creature_part_rotation)
					
		ExistingCellDataArray.append(CellData.new(cell.position, cell_instance, has_core_creature_part, outer_creature_part_positions, []))
		
class CellBlueprintData:
	var position: Vector2
	func _init(_position):
		position = _position

var CellBlueprintDataArray: Array[CellBlueprintData] = []

func _check_if_existing_blueprint(blueprint_pos: Vector2):
	for cell_blueprint_data in CellBlueprintDataArray:
		if cell_blueprint_data.position == blueprint_pos:
			return cell_blueprint_data
	return null

func _check_if_existing_cell_part(blueprint_pos: Vector2):
	for cell in creature_resource.creature_data_array:
		if cell.position == blueprint_pos:
			return "EXISTING_CELL"
		for outer_creature_part in cell.outer_creature_parts:
			if outer_creature_part.pos_to_origin == blueprint_pos:
				return "EXISTING_OUTER_COMP"
	return null

func _append_possible_cell_blueprint_positions(cell_position: Vector2) -> void:
	var blueprint_pos: Vector2
	var existing_blueprint: CellBlueprintData
	var existing_cell_part
	for local_position in [1,2,3,4,5,6]:
		
		blueprint_pos = _get_global_position_based_on_local_position(local_position, cell_position)
		
		# Check if existing cell or component in this position
		existing_blueprint = _check_if_existing_blueprint(blueprint_pos)
		existing_cell_part = _check_if_existing_cell_part(blueprint_pos)
		if existing_blueprint != null:
			pass
		elif existing_cell_part == null:
			CellBlueprintDataArray.append(CellBlueprintData.new(blueprint_pos))

func _display_cell_blueprints():
	#Instantiate "Cell Blueprints" Node3D. All cell blueprints will be a child of this node.
	cell_blueprints_collection_instance = _spawn_thing(CELL_BLUEPRINTS, interface, Vector3(), Vector3())
	cell_editors_collection_instance = _spawn_thing(CELL_EDITORS, interface, Vector3(), Vector3())

	# Instance Cell Edit Areas (for existing cells)
	for cell in creature_resource.creature_data_array:
		# Setup the CellBlueprintDataArray
		_append_possible_cell_blueprint_positions(cell.position)
		
		var cell_edit_area_instance = _spawn_thing(CELL_EDITOR_AREA, cell_editors_collection_instance, _unpack_cell_position(cell.position), Vector3())
		var properties = cell_edit_area_instance.get_node("Components").get_node("Properties")
		var cell_instance: Node3D
		
		# Find which cell the current celleditarea corresponds to
		for existing_cell_data in ExistingCellDataArray:
			if existing_cell_data.position == cell.position:
				cell_instance = existing_cell_data.cell
		
		# Set Properties
		properties.position = cell.position
		properties.cell = cell_instance
		properties.cell_meshes = cell_instance.get_children()
		
		if cell.core_creature_part != null:
			properties.has_core_creature_part = true
		
		for outer_creature_part in cell.outer_creature_parts:
			properties.outer_creature_part_positions.append(outer_creature_part.position)

	# Instance Cell Blueprints (for potential cells) Using CellBlueprintDataArray
	for cell_blueprint_data in CellBlueprintDataArray:
		var cell_blueprint_instance: Node3D = _spawn_thing(BASIC_CELL_BLUEPRINT, cell_blueprints_collection_instance, _unpack_cell_position(cell_blueprint_data.position), Vector3())
		cell_blueprint_instance.get_node("Components/Properties").position = cell_blueprint_data.position

func globalDisplayCreatureData():
	
	# Clear all pre-existing instances and data arrays.
	CellBlueprintDataArray.clear()
	ExistingCellDataArray.clear()
	if is_instance_valid(body_instance):
		body_instance.queue_free()
	if is_instance_valid(cell_blueprints_collection_instance):
		cell_blueprints_collection_instance.queue_free()
	if is_instance_valid(cell_editors_collection_instance):
		cell_editors_collection_instance.queue_free()
	
	_display_creature()
	_display_cell_blueprints()

func globalHideCellBlueprints():
	if is_instance_valid(cell_blueprints_collection_instance):
		cell_blueprints_collection_instance.queue_free()
	else:
		print_debug("no cell blueprints collection instance")

func globalDisplayPossibleCreatureParts(cell_pos: Vector2, has_core_creature_part: bool, outer_creature_part_positions: Array[int]):
	globalHideCellBlueprints()
	cell_blueprints_collection_instance = _spawn_thing(CELL_BLUEPRINTS, interface, Vector3(), Vector3())
	
	var unpacked_cell_pos = _unpack_cell_position(cell_pos)
	
	# Instance core component blueprint if doesn't already have one
	if !has_core_creature_part:
		var core_creature_part_blueprint_instance = _spawn_thing(CORE_BLUEPRINT, cell_blueprints_collection_instance, unpacked_cell_pos, Vector3())
		core_creature_part_blueprint_instance.properties.position = cell_pos
	
	# Create an array with all the available positions for outer components
	var available_outer_creature_part_positions: Array[int] = [1,2,3,4,5,6]
	for outer_creature_part_position in outer_creature_part_positions:
		available_outer_creature_part_positions.erase(outer_creature_part_position)
	
	for outer_creature_part_position in available_outer_creature_part_positions:
		var global_blueprint_position: Vector2 = _get_global_position_based_on_local_position(outer_creature_part_position, cell_pos)
		
		if _check_if_existing_cell_part(global_blueprint_position) != null:
			continue
		
		var unpacked_outer_comp_pos = _unpack_cell_position(global_blueprint_position)
		var blueprint_rotation: Vector3 = _get_component_rotation_based_on_local_position(outer_creature_part_position)
		
		var outer_creature_part_blueprint_instance = _spawn_thing(OUTER_BLUEPRINT, cell_blueprints_collection_instance, unpacked_outer_comp_pos, blueprint_rotation)
		outer_creature_part_blueprint_instance.properties.creature_part_position = outer_creature_part_position
		outer_creature_part_blueprint_instance.properties.position = cell_pos
		
func _ready():
	call_deferred("globalDisplayCreatureData")
