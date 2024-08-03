extends Node

@onready var creature_resource = Globals.player_creature_data
@onready var body = creature_resource.body

@onready var interface = get_parent().get_parent()

const BASIC_CELL_BLUEPRINT = preload("res://Evolution Scene/Scenes/Cell Part Blueprints/cell blueprint/basiccellblueprint.tscn")
const CELL_EDITOR_AREA = preload("res://Evolution Scene/Scenes/celleditorarea.tscn")
const CELL_BLUEPRINTS = preload("res://Evolution Scene/Scenes/CellBlueprints.tscn")

var body_instance: Node3D
var cell_blueprints_collection_instance: Node3D

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

class ExistingCellData:
	var position: Vector2
	var cell: Node3D
	func _init(_position, _cell):
		position = _position
		cell = _cell

var ExistingCellDataArray: Array[ExistingCellData] = []

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
		ExistingCellDataArray.append(ExistingCellData.new(cell.position, cell_instance))
		
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

class CellBlueprintData:
	var parent_cell_position_array: Array[Vector2]
	var position: Vector2
	func _init(_parent_cell_position_array, _position):
		parent_cell_position_array = _parent_cell_position_array
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
		for outer_component in cell.outer_components:
			if outer_component.pos_to_origin == blueprint_pos:
				return "EXISTING_OUTER_COMP"
	return null

func _append_possible_cell_blueprint_positions(cell_position: Vector2, parent_cell_position_array: Array[Vector2]) -> void:
	var blueprint_pos: Vector2
	var existing_blueprint: CellBlueprintData
	var existing_cell_part
	for number in [1,2,3,4,5,6]:
		blueprint_pos = cell_position
		match number:
			1:
				blueprint_pos.y -= 1
			2:
				if int(blueprint_pos.x) & 1: # if odd:
					blueprint_pos.x -= 1
				else: # if even
					blueprint_pos.x -= 1
					blueprint_pos.y -= 1
			3:
				if int(blueprint_pos.x) & 1:
					blueprint_pos.x -= 1
					blueprint_pos.y += 1
				else:
					blueprint_pos.x -= 1
			4:
				blueprint_pos.y += 1
			5:
				if int(blueprint_pos.x) & 1:
					blueprint_pos.x += 1
					blueprint_pos.y += 1
				else:
					blueprint_pos.x += 1
			6:
				if int(blueprint_pos.x) & 1:
					blueprint_pos.x += 1
				else:
					blueprint_pos.x += 1
					blueprint_pos.y -= 1
		existing_blueprint = _check_if_existing_blueprint(blueprint_pos)
		existing_cell_part = _check_if_existing_cell_part(blueprint_pos)
		if existing_blueprint != null:
			existing_blueprint.parent_cell_position_array.append(cell_position)
		elif existing_cell_part == null:
			var parent_cell_pos_array: Array[Vector2] = [cell_position]
			CellBlueprintDataArray.append(CellBlueprintData.new(parent_cell_pos_array, blueprint_pos))

func _display_cell_blueprints():
	#Instantiate "Cell Blueprints" Node3D. All cell blueprints will be a child of this node.
	cell_blueprints_collection_instance = _spawn_thing(CELL_BLUEPRINTS, interface, Vector3(), Vector3())
	
	for cell in creature_resource.creature_data_array:
		_append_possible_cell_blueprint_positions(cell.position, cell.parent_cell_position_array)
		var cell_edit_area_instance = _spawn_thing(CELL_EDITOR_AREA, cell_blueprints_collection_instance, _unpack_cell_position(cell.position), Vector3())
		var properties = cell_edit_area_instance.get_node("Components").get_node("Properties")
		var cell_instance: Node3D
		for existing_cell_data in ExistingCellDataArray:
			if existing_cell_data.position == cell.position:
				cell_instance = existing_cell_data.cell
		properties.position = cell.position
		properties.cell = cell_instance
		properties.cell_meshes = cell_instance.get_children()

	for cell_blueprint_data in CellBlueprintDataArray:
		var cell_blueprint_instance: Node3D = _spawn_thing(BASIC_CELL_BLUEPRINT, cell_blueprints_collection_instance, _unpack_cell_position(cell_blueprint_data.position), Vector3())
		cell_blueprint_instance.get_node("Components/Properties").position = cell_blueprint_data.position

func globalDisplayCreatureData():
	CellBlueprintDataArray.clear()
	ExistingCellDataArray.clear()
	if is_instance_valid(body_instance):
		body_instance.queue_free()
	if is_instance_valid(cell_blueprints_collection_instance):
		cell_blueprints_collection_instance.queue_free()
	_display_creature()
	_display_cell_blueprints()
	
func _ready():
	call_deferred("globalDisplayCreatureData")
