extends Node

@export var branching_chance: float = 0
@export var branch_num: int = 0

@export var num_of_initial_rooms: int
@export var rows_to_boss: int
@export var path_map = {} # Key:Value pair with Key = coordinates, value = room

@export var map_x_max = 14

# the plan:
# path_map represents a grid, 0,0 is the bottom left corner cell.
# only positive integer values for x and y coordinates for spots in grid are allowed.
# branches will spawn in a range from 0th cell to 10th cell. RANDOMLY.
# therefore, at start when deciding what cell to put the starting room in a branch, its a random chance that gets larger based on num of branches left and num of cells left in starting row.

# The map:
# the map will start will maximum of 8 starting nodes for the branches to start from.

# Rest of the plan is in the design notebook.


#ctrl + r: find and replace

class Room:
	var type: String
	func _init(_type):
		type = _type

func _create_room(xpos: int, ypos: int, room_type: String):
	path_map[Vector2(xpos, ypos)] = Room.new(room_type)

func _determine_branch_starting_room(initial_rooms_left, possible_cells):
	var probability = (float(initial_rooms_left) / float(possible_cells.size())) * 100
	var rand_num = randf_range(0,100)
	if rand_num <= probability:
		#create room at cell
		_create_room(possible_cells[0], 0, "fight")
		initial_rooms_left -= 1
		possible_cells.remove_at(0)
		return [initial_rooms_left, possible_cells]
	else:
		#remove cell from possible cells
		possible_cells.remove_at(0)
		return _determine_branch_starting_room(initial_rooms_left, possible_cells)

func _establish_starting_rooms(num_of_initial_rooms: int):
	# each branch's starting room may only occupy cells that have an even x coordinate.
	var possible_cells = [0,2,4,6,8,10,12,14]
	var initial_rooms_left = num_of_initial_rooms
	for i in range(num_of_initial_rooms):
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
	
	#print("Row Num: %d, Row Y Coordinate: %d, Row X Status: Even" % [row, row_y_coordinate])
	#print("Eligible Rooms:")
	#print(eligible_rooms)
	#print("")
	
	# Loop over eligible_rooms array. For every room, check the position in x-1 to see if a room is there, and if so, remove those coordinates from possible extension spots 
	for room_pos in eligible_rooms:
		var eligible_extension_positions = [Vector2(room_pos.x - 1, room_pos.y), Vector2(room_pos.x, room_pos.y + 1), Vector2(room_pos.x + 1, room_pos.y)]
			
		#If possible extension is out of bounds, remove from list.
		for eligible_position in eligible_extension_positions:
			if !(0 <= eligible_position.x and eligible_position.x <= map_x_max):
				eligible_extension_positions.erase(eligible_position)
				
		#print("Eligible extension positions for the position %v" % room_pos)
		#print(eligible_extension_positions)
		#print("")
		
		# There is a 10% chance for number of extensions to be 2 instead of 1, and a 1% chance that number of extension is 3.
		var rand_num = randf_range(0,100)
		var extensions = 1
		if rand_num <= branching_chance:
			rand_num = randf_range(0,100)
			if rand_num <= branching_chance:
				extensions = 3
				branching_chance -= branch_num
				branch_num += 2
			else:
				extensions = 2
				branching_chance -= branch_num * 2
				branch_num += 1
		else:
			branching_chance += 50 - branch_num
		
		# For every eligible extension position, run code to determine if it is chosen.
		var eligible_extension_positions_left = eligible_extension_positions.size()
		for eligible_position in eligible_extension_positions:
			var probability = (float(extensions) / float(eligible_extension_positions_left)) * 100
			rand_num = randf_range(0,100)
			
			if rand_num <= probability:
				# the current position is chosen
				#print("room created with probability %f" % probability)
				#print("created room's position:")
				#print(eligible_position)
				#print("")
				
				_create_room(eligible_position.x, eligible_position.y, "fight")
				eligible_extension_positions.clear()
			else:
				#print("room not created with probability %f" % probability)
				eligible_extension_positions_left -= 1
	
func _extend_odd_row_rooms(row):
	var row_y_coordinate = float(row-1) / float(2)
	
	var eligible_rooms = {}
	for room_pos in path_map.keys():
		if int(room_pos.x) & 1 and room_pos.y == row_y_coordinate:
			eligible_rooms[room_pos] = path_map[room_pos]
	
	#print("Row Num: %d, Row Y Coordinate: %d, Row X Status: Odd" % [row, row_y_coordinate])
	#print("Eligible Rooms:")
	#print(eligible_rooms)
	#print("")
	
	for room_pos in eligible_rooms:
		var eligible_extension_positions = [Vector2(room_pos.x - 1, room_pos.y + 1), Vector2(room_pos.x, room_pos.y + 1), Vector2(room_pos.x + 1, room_pos.y + 1)]
		
		
		#If possible extension is out of bounds, remove from list.
		for eligible_position in eligible_extension_positions:
			if !(0 <= eligible_position.x and eligible_position.x <= map_x_max):
				eligible_extension_positions.erase(eligible_position)
				
		#print("Eligible extension positions for the position %v" % room_pos)
		#print(eligible_extension_positions)
		#print("")
		
		# There is a 10% chance for number of extensions to be 2 instead of 1, and a 1% chance that number of extension is 3.
		var rand_num = randf_range(0,100)
		var extensions = 1
		if rand_num <= branching_chance:
			rand_num = randf_range(0,100)
			if rand_num <= branching_chance:
				extensions = 3
				branching_chance -= 5
				branch_num += 2
			else:
				extensions = 2
				branching_chance -= 2.5
				branch_num += 1
		else:
			branching_chance += 5
		
		var eligible_extension_positions_left = eligible_extension_positions.size()
		for eligible_position in eligible_extension_positions:
			var probability = (float(extensions) / float(eligible_extension_positions_left)) * 100
			rand_num = randf_range(0,100)
			if rand_num <= probability:
				# the current position is chosen
				#print("room created with probability %f" % probability)
				#print("created room's position:")
				#print(eligible_position)
				#print("")
				
				_create_room(eligible_position.x, eligible_position.y, "fight")
				extensions -= 1
				if extensions <= 0:
					eligible_extension_positions.clear()
				else:
					eligible_extension_positions_left -= 1
			else:
				#print("room not created with probability %f" % probability)
				eligible_extension_positions_left -= 1
	
func _extend_rooms_in_row(row):
	#first determine if row num is even or odd
	if row & 1: # & in this situation means bitwize operator, basically determines if the number is odd and returns true if so.
		_extend_odd_row_rooms(row)
	else:
		_extend_even_row_rooms(row)
	

func _create_path_map(num_of_initial_rooms: int, rows_to_boss: int):
	# First, decide what cells each branch will start with
	_establish_starting_rooms(num_of_initial_rooms)
	#print("Starting room positions:")
	#print(path_map)
	#print("")
	
	# Then, go through each each cell in each row and instantiate a continuation room for each one. 
	for row in range(rows_to_boss):
		_extend_rooms_in_row(row)

func _ready():
	_create_path_map(num_of_initial_rooms, rows_to_boss)
	#print(path_map)
