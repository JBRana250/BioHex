extends CreatureRotationScript

@onready var creature_transform_basis: Node3D = creature.Dependencies["creature_transform_basis"]

#Set parent's export variables to new values
func _init():
	rotation_speed = 1.25

func _RotateBodyInDirection(direction, delta):
	var dir = null
	match direction:
		"clockwise":
			dir = 1
		"counterclockwise":
			dir = -1
	#change rotation
	creature.rotation.y += rotation_speed * delta * dir
	creature_transform_basis.rotation.y += rotation_speed * delta * dir

func _physics_process(delta):
	if !is_instance_valid(body):
		return
	direction_to_rotate = get_rotation_direction_component.globalGetRotationDirection()
	forward_dir = body.get_global_transform().basis.z #Vector3 with (x, 0, z) representing direction player is facing
	DebugOverlay.draw.add_vector(creature.position, creature.position + forward_dir*2, 2, Color.SKY_BLUE, false)
	#check if forward_dir is close to player_mousevector
	var vectordiff: Vector3 = direction_to_rotate.normalized() - forward_dir.normalized()
	if -rotationclampfloat < vectordiff.x and  vectordiff.x < rotationclampfloat and -rotationclampfloat < vectordiff.z and vectordiff.z < rotationclampfloat:
		return
	#get clockwise angle between two vectors
	var angle: float = _CalculateAngleBetweenVectors(Vector2(direction_to_rotate.x, direction_to_rotate.z), Vector2(forward_dir.x, forward_dir.z))
	if angle >= 0:
		_RotateBodyInDirection("clockwise", delta)
	if angle < 0:
		_RotateBodyInDirection("counterclockwise", delta)
