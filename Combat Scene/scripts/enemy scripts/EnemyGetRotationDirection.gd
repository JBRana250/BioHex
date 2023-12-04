extends GetRotationDirectionScript

func _GetRotationDirection():
	#return the vector between player and the enemy
	var enemy_playervector = Globals.player.global_position - owner.global_position
	#DebugOverlay.draw.add_vector(owner.global_position, owner.global_position + enemy_playervector, 1, Color.DARK_GREEN, false)
	return owner.global_position + enemy_playervector
