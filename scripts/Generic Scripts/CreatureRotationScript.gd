extends Node
class_name CreatureRotationScript

@onready var body = $"../../Body"
@onready var get_rotation_direction_component = $"../GetRotationDirectionComponent"

@export var rotation_speed: float = 4
@export var rotationclampfloat: float = 0.1

@export var direction_to_rotate: Vector3
@export var forward_dir: Vector3

func _RotateVector(vector_to_rotate, angle):
	#rotate vector by angle
	#construct a new coordinate system with x axis represented by the vector (cos theta, sin theta) and y axis represented by the vector (-sin theta, cos theta)
	var vectorx = Vector2(cos(angle), sin(angle))
	var vectory = Vector2(-sin(angle), cos(angle))
	return vector_to_rotate.x * vectorx + vector_to_rotate.z * vectory
	
func _CalculateAngleBetweenVectors(vector1, vector2):
	var dot: float = vector1.x*vector2.x + vector1.y*vector2.y      # Dot product between [x1, y1] and [x2, y2]
	var det: float = vector1.x*vector2.y - vector1.y*vector2.x      # Determinant
	return atan2(det, dot) # atan2(y, x) or atan2(sin, cos). This will return an angle that will be positive for clockwise angles and negative for anticlockwise angles.

func _GetYPosBasedOnPart(part):
	if part.is_in_group("cellcolbox"):
		return 0.046
	if part.is_in_group("outermodcolbox"):
		return 0
	if part.is_in_group("coremodcolbox"):
		return 0.35
	if part.is_in_group("cellcastercolbox"):
		return 1
	print("cell part %s's group could not be attained" % part.name)
	return 0

func _RotateBodyInDirection(direction, delta):
	var dir = null
	if direction == "clockwise":
		dir = 1
	if direction == "counterclockwise":
		dir = -1
	#change rotation
	body.rotation.y += rotation_speed * delta * dir
	#iterate through all colliders
	for child in owner.get_children():
		if child.is_in_group("creaturecollisionbox"):
			#get vector between child and player origin
			var distvector: Vector3 = child.position - Vector3()
			var rotated_vector: Vector2 = _RotateVector(distvector, -rotation_speed * delta * dir)
			var ypos = _GetYPosBasedOnPart(child)
			child.position = Vector3(rotated_vector.x, ypos, rotated_vector.y)
			child.rotation.y += rotation_speed * delta * dir
		if child.name == "Corecollisionbox":
			child.rotation.y += rotation_speed * delta * dir

func globalGetAngleBetweenForwardAndDesiredDirection():
	return _CalculateAngleBetweenVectors(Vector2(direction_to_rotate.x, direction_to_rotate.z), Vector2(forward_dir.x, forward_dir.z))

func _physics_process(delta):
	if is_instance_valid(body):
		direction_to_rotate = get_rotation_direction_component.globalGetRotationDirection()
		forward_dir = body.get_global_transform().basis.z #Vector3 with (x, 0, z) representing direction player is facing
		DebugOverlay.draw.add_vector(owner.position, owner.position + forward_dir*2, 2, Color.SKY_BLUE, false)
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
