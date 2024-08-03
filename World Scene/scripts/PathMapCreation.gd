extends Node


@export var num_of_initial_rooms: int
@export var rows_to_boss: int
@export var path_map = {} # Key:Value pair with Key = coordinates, value = room

@export var map_x_max = 14

class Room:
	var type: String # combat, shop, treasure, boss
	var branching_chance: float
	func _init(_type, _branching_chance):
		type = _type
		branching_chance = _branching_chance

func _create_room(xpos: int, ypos: int, room_type: String, branching_chance: float):
	path_map[Vector2(xpos, ypos)] = Room.new(room_type, branching_chance)

func _determine_branch_starting_room(initial_rooms_left, possible_cells):
	var probability = (float(initial_rooms_left) / float(possible_cells.size())) * 100
	var rand_num = randf_range(0,100)
	if rand_num <= probability:
		#create room at cell
		_create_room(possible_cells[0], 0, "combat", 0)
		initial_rooms_left -= 1
		possible_cells.remove_at(0)
		return [initial_rooms_left, possible_cells]
	else:
		#remove cell from possible cells
		possible_cells.remove_at(0)
		return _determine_branch_starting_room(initial_rooms_left, possible_cells)

func _establish_starting_rooms(_num_of_initial_rooms: int):
	# each branch's starting room may only occupy cells that have an even x coordinate.
	var possible_cells = [0,2,4,6,8,10,12,14]
	var initial_rooms_left = _num_of_initial_rooms
	for i in range(_num_of_initial_rooms):
		var results = _determine_branch_starting_room(initial_rooms_left, possible_cells)
		initial_rooms_left = results[0]
		possible_cells = results[1]

func _extend_even_row_rooms(row):
	var row_y_coordinate = float(row) / float(2)
	
	#Iterate over path_map and put all rooms that match the above criteria (y coordinate + x status) into an array. Then loop over than array to do stuff (noted in design notebook)
	var eligible_rooms = {} 
	for room_pos in path_map.keys():
		if !int(room_pos.x) & 1 and room_pos.y == row_y_coordinate:
			eligible_rooms[room_pos] = path_map[room_pos]

	# Loop over eligible_rooms array. For every room, check the position in x-1 to see if a room is there, and if so, remove those coordinates from possible extension spots 
	for room_pos in eligible_rooms:
		var room = path_map[room_pos]
		var possible_eligible_extension_positions = [Vector2(room_pos.x - 1, room_pos.y), Vector2(room_pos.x, room_pos.y + 1), Vector2(room_pos.x + 1, room_pos.y)]
		var eligible_extension_positions = []
			
		#If possible extension is out of bounds, remove from list.
		for eligible_position in possible_eligible_extension_positions:
			if !(0 <= eligible_position.x and eligible_position.x <= map_x_max):
				continue
			if rows_to_boss % 2 == 1:
				if eligible_position.y > (float(rows_to_boss-1) / float(2)): # if placed on y value beyond boss row
					continue
				if row == rows_to_boss-1 and int(eligible_position.x) % 2 == 0:
					continue
				eligible_extension_positions.append(eligible_position)
			elif rows_to_boss % 2 == 0:
				if eligible_position.y > (float(rows_to_boss) / float(2)): # if placed on y value beyond boss row
					continue
				eligible_extension_positions.append(eligible_position)
			else:
				print_debug("rows_to_boss is neither odd nor even?!?")

		# There is a 10% chance for number of extensions to be 2 instead of 1, and a 1% chance that number of extension is 3.
		var rand_num = randf_range(0,100)
		var new_branching_chance = 0
		var extensions = 1
		if rand_num <= room.branching_chance:
			rand_num = randf_range(0,100)
			if rand_num <= room.branching_chance:
				extensions = 3
				new_branching_chance = room.branching_chance - 15
			else:
				extensions = 2
				new_branching_chance = room.branching_chance - 10
		else:
			new_branching_chance = room.branching_chance + 20
		
		# For every eligible extension position, run code to determine if it is chosen.
		var eligible_extension_positions_left = eligible_extension_positions.size()
		for eligible_position in eligible_extension_positions:
			var probability = (float(extensions) / float(eligible_extension_positions_left)) * 100
			rand_num = randf_range(0,100)
			
			if rand_num <= probability:
				# the current position is chosen
				_create_room(eligible_position.x, eligible_position.y, "combat", new_branching_chance)
				extensions -= 1
				if extensions <= 0:
					break
				else:
					eligible_extension_positions_left -= 1
			else:
				#print("room not created with probability %f" % probability)
				eligible_extension_positions_left -= 1
		print()
	
func _extend_odd_row_rooms(row):
	var row_y_coordinate = float(row-1) / float(2)
	
	var eligible_rooms = {}
	for room_pos in path_map.keys():
		if int(room_pos.x) & 1 and room_pos.y == row_y_coordinate:
			eligible_rooms[room_pos] = path_map[room_pos]

	for room_pos in eligible_rooms:
		var room = path_map[room_pos]
		var possible_eligible_extension_positions = [Vector2(room_pos.x - 1, room_pos.y + 1), Vector2(room_pos.x, room_pos.y + 1), Vector2(room_pos.x + 1, room_pos.y + 1)]
		var eligible_extension_positions = []
		#If possible extension is out of bounds, remove from list.
		for eligible_position in possible_eligible_extension_positions:
			if !(0 <= eligible_position.x and eligible_position.x <= map_x_max):
				continue
			if rows_to_boss % 2 == 0:
				if eligible_position.y > (float(rows_to_boss) / float(2)): # if placed on y value beyond boss row
					continue
				if row == rows_to_boss-1 and int(eligible_position.x) % 2 == 1:
					continue
				eligible_extension_positions.append(eligible_position)
			elif rows_to_boss % 2 == 1:
				if eligible_position.y > (float(rows_to_boss-1) / float(2)): # if placed on y value beyond boss row
					continue
				eligible_extension_positions.append(eligible_position)
			else:
				print_debug("rows_to_boss is neither odd nor even?!?")
		
		# There is a 10% chance for number of extensions to be 2 instead of 1, and a 1% chance that number of extension is 3.
		var rand_num = randf_range(0,100)
		var new_branching_chance = 0
		var extensions = 1
		if rand_num <= room.branching_chance:
			rand_num = randf_range(0,100)
			if rand_num <= room.branching_chance:
				extensions = 3
				new_branching_chance = room.branching_chance - 100
			else:
				extensions = 2
				new_branching_chance = room.branching_chance - 25
		else:
			new_branching_chance = room.branching_chance + 5
		
		var eligible_extension_positions_left = eligible_extension_positions.size()
		for eligible_position in eligible_extension_positions:
			var probability = (float(extensions) / float(eligible_extension_positions_left)) * 100
			rand_num = randf_range(0,100)
			if rand_num <= probability:
				# the current position is chosen
				_create_room(eligible_position.x, eligible_position.y, "combat", new_branching_chance)
				extensions -= 1
				if extensions <= 0:
					break
				else:
					eligible_extension_positions_left -= 1
			else:
				#print("room not created with probability %f" % probability)
				eligible_extension_positions_left -= 1
		print()
	
func _extend_rooms_in_row(row):
	#first determine if row num is even or odd
	if row & 1: # & in this situation means bitwize operator, basically determines if the number is odd and returns true if so.
		_extend_odd_row_rooms(row)
	else:
		_extend_even_row_rooms(row)
	

func _create_path_map(_num_of_initial_rooms: int, _rows_to_boss: int):
	# First, decide what cells each branch will start with
	_establish_starting_rooms(_num_of_initial_rooms)
	
	# Then, go through each each cell in each row and instantiate a continuation room for each one. 
	for row in range(_rows_to_boss):
		_extend_rooms_in_row(row)

func _ready():
	if Globals.path_map == {}:
		_create_path_map(num_of_initial_rooms, rows_to_boss)
	else:
		path_map = Globals.path_map
		rows_to_boss = Globals.rows_to_boss
	Globals.path_map = path_map
	Globals.rows_to_boss = rows_to_boss
