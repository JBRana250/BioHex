extends Node3D
class_name GetRotationDirectionScript

signal rotate_rangedweapons(player_mousevector, delta)

func globalGetRotationDirection(): #what direction does it want to rotate in
	var rotation_direction: Vector3 = _GetRotationDirection() - Vector3(owner.position.x, 0, owner.position.z) #Vector 3 with (x, 0, z) representing a vector between the player and the mouse cursor
	return rotation_direction
	
func _GetRotationDirection():
	return Vector3()
