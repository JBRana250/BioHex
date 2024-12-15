extends Node

func _ready():
	if Globals.rooms_cleared == 0:
		PlayerResources.fresh_player = true
	else:
		PlayerResources.fresh_player = false
