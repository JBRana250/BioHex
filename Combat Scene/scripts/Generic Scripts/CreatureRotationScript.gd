extends Node
class_name CreatureRotationScript

var creature
@onready var body = creature.Dependencies["body"]
@export var get_rotation_direction_component: Node3D
@export var mana_component: Node

@export var rotation_speed: float = 4
@export var rotationclampfloat: float = 0.1

@export var direction_to_rotate: Vector3
@export var forward_dir: Vector3

func _CalculateAngleBetweenVectors(vector1, vector2):
	var dot: float = vector1.x*vector2.x + vector1.y*vector2.y      # Dot product between [x1, y1] and [x2, y2]
	var det: float = vector1.x*vector2.y - vector1.y*vector2.x      # Determinant
	return atan2(det, dot) # atan2(y, x) or atan2(sin, cos). This will return an angle that will be positive for clockwise angles and negative for anticlockwise angles.

func _RotateBodyInDirection(direction, delta):
	if mana_component.mana <= 0:
		return
	var dir = null
	match direction:
		"clockwise":
			dir = 1
		"counterclockwise":
			dir = -1
	#change rotation
	var old_creature_rotation = creature.rotation.y
	var new_creature_rotation = old_creature_rotation + (rotation_speed * delta * dir)
	var mana_usage = abs(new_creature_rotation - old_creature_rotation)
	mana_component.globalDecreaseMana(mana_usage * 0.05)
	creature.rotation.y = new_creature_rotation

func globalGetAngleBetweenForwardAndDesiredDirection():
	return _CalculateAngleBetweenVectors(Vector2(direction_to_rotate.x, direction_to_rotate.z), Vector2(forward_dir.x, forward_dir.z))

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
