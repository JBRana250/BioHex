extends Node

@export var room_scene = preload("res://World Scene/scenes/room.tscn")
@onready var CombatRoomReferences = owner.find_child("CombatRoomReferences")
@onready var path_map = Globals.path_map
@onready var rows_to_boss = Globals.rows_to_boss

@onready var path = get_parent().get_parent()
# The Plan:
# Rooms are instantiated row by row, starting from row 0, all the way to row n
# Loop through every key in path_map, for every key that matches the criteria for the current row.

func _instantiate_even_row_rooms(row):
	#Get all rooms from path_map that correspond with the current row
	var row_y_coordinate = float(row) / float(2)
	var eligible_rooms = {} 
	for room_pos in path_map.keys():
		if !int(room_pos.x) & 1 and room_pos.y == row_y_coordinate:
			eligible_rooms[room_pos] = path_map[room_pos]
	#loop over all eligible rooms
	for room_pos in eligible_rooms:
		#Get distance of current room from origin (0,0)
		var x_dist = float(room_pos.x) / float(2)
		var y_dist = room_pos.y
		# For every unit of x distance, the real world distance increases by 2.9. For every unit of y distance, the real world z decreases by 1.7. This distance is measured from the origin (-10.25, 0, 6.35)
		var world_x_increment = x_dist * 2.9
		var world_z_increment = y_dist * 1.7
		var world_dist = Vector3(-10.25 + world_x_increment, 0, 6.35 - world_z_increment)
		
		#Instantiate the room and set parent to current scene
		var room_instance = room_scene.instantiate()
		path.add_child.call_deferred(room_instance)
		
		#Set room position
		room_instance.position = world_dist
		
		#Set room attributes
		var attributes = room_instance.find_child("Components").find_child("RoomAttributes")
		attributes.room_pos = room_pos
		attributes.row_num = row
		attributes.res_path = CombatRoomReferences.spikewalker3

func _instantiate_odd_row_rooms(row):
	var row_y_coordinate = float(row-1) / float(2)
	
	var eligible_rooms = {}
	for room_pos in path_map.keys():
		if int(room_pos.x) & 1 and room_pos.y == row_y_coordinate:
			eligible_rooms[room_pos] = path_map[room_pos]
	#loop over all eligible rooms
	for room_pos in eligible_rooms:
		#Get distance of current room from origin (1,0)
		var x_dist = float(room_pos.x - 1)/float(2)
		var y_dist = room_pos.y
		# For every unit of x distance, the real world distance increases by 2.9. For every unit of y distance, the real world z distance decreases by 1.7. This distance is measured from the origin (-8.8, 0, 5.5)
		var world_x_increment = x_dist * 2.9
		var world_z_increment = y_dist * 1.7
		var world_dist = Vector3(-8.8 + world_x_increment, 0, 5.5 - world_z_increment)
		
		#Instantiate the room and set parent to current scene
		var room_instance = room_scene.instantiate()
		path.add_child.call_deferred(room_instance)
		
		#Set room position
		room_instance.position = world_dist
		
		#Set room attributes
		var attributes = room_instance.find_child("Components").find_child("RoomAttributes")
		attributes.room_pos = room_pos
		attributes.row_num = row
		attributes.res_path = CombatRoomReferences.spikewalker3

func _instantiate_rooms_in_row(row):
	#first determine if row num is even or odd
	if row & 1: # & in this situation means bitwize operator, basically determines if the number is odd and returns true if so.
		_instantiate_odd_row_rooms(row)
	else:
		_instantiate_even_row_rooms(row)

func _ready():
	for row in range(rows_to_boss+1):
		_instantiate_rooms_in_row(row)
