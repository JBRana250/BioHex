extends Node

# This script isn't used anywhere, it just stores functions that you can copy-paste to scripts that need it.

## Information Classes ##

class CellData:
	var position: Vector2
	var cell: Node3D
	var core_creature_part: bool = false
	var outer_creature_parts_positions: Array[int] = []
	var parent_cells: Array[CellData]
	func _init(_position, _cell, _has_core_creature_part, _outer_creature_parts_positions, _parent_cells):
		position = _position
		cell = _cell
		core_creature_part = _has_core_creature_part
		outer_creature_parts_positions = _outer_creature_parts_positions
		parent_cells = _parent_cells

## Get Information ##

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

func _check_if_connected_cell(cell: Cell_Resource, already_investigated_cells_array: Array[Cell_Resource]) -> bool:
	
	already_investigated_cells_array.append(cell)
	
	for adjacent_cell in cell.adjacent_cell_array:
		if adjacent_cell in already_investigated_cells_array:
			continue
		if adjacent_cell.position == Vector2(0,0):
			return true
		
		_check_if_connected_cell(adjacent_cell, already_investigated_cells_array)
	
	return false

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

## Checking Stuff ##

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

## Spawning ##

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





## Components ##

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
