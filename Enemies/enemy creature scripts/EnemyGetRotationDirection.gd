extends GetRotationDirectionScript

func _GetRotationDirection():
	if !is_instance_valid(Globals.player):
		return Vector3()
	#return the vector between player and the enemy
	var enemy_playervector = Globals.player.global_position - creature.global_position
	#DebugOverlay.draw.add_vector(owner.global_position, owner.global_position + enemy_playervector, 1, Color.DARK_GREEN, false)
	return creature.global_position + enemy_playervector
