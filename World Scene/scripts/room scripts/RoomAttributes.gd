extends Node

@export var room_pos: Vector2
@export var row_num: int
@export var eligible_to_travel: bool
@export var res_path: String

#Treasure room attributes
@export var keys_needed: int

func _ready():
	var current_room_pos = Globals.current_room_pos
	
	if Globals.current_row != -1:
		var eligible_travel_rooms = []
		if Globals.current_row & 1: #if player is currently on odd row
			eligible_travel_rooms = [Vector2(current_room_pos.x - 1, current_room_pos.y + 1), Vector2(current_room_pos.x, current_room_pos.y + 1), Vector2(current_room_pos.x + 1, current_room_pos.y + 1)]
		else:
			eligible_travel_rooms = [Vector2(current_room_pos.x - 1, current_room_pos.y), Vector2(current_room_pos.x, current_room_pos.y + 1), Vector2(current_room_pos.x + 1, current_room_pos.y)]
		
		eligible_to_travel = false
		for eligible_travel_room in eligible_travel_rooms:
			if room_pos == eligible_travel_room:
				eligible_to_travel = true
	else:
		eligible_to_travel = false
		if row_num == 0:
			eligible_to_travel = true
