extends Node

@export var ranged_rotation_speed: float = 5
@export var rotationclampfloat: float = 0.1
@export var ranged_weapons_dir = Vector2(0,1)

@onready var ranged_weapons: Node3D = $"../../Body/RangedWeapons"
@onready var get_rotation_direction_component = $"../GetRotationDirectionComponent"


func _RotateVector(vector_to_rotate, angle):
	#rotate vector by angle
	#construct a new coordinate system with x axis represented by the vector (cos theta, sin theta) and y axis represented by the vector (-sin theta, cos theta)
	var vectorx = Vector2(cos(angle), sin(angle))
	var vectory = Vector2(-sin(angle), cos(angle))
	return vector_to_rotate.x * vectorx + vector_to_rotate.y * vectory

func _CalculateAngleBetweenVectors(vector1, vector2):
	var dot: float = vector1.x*vector2.x + vector1.y*vector2.y      # Dot product between [x1, y1] and [x2, y2]
	var det: float = vector1.x*vector2.y - vector1.y*vector2.x      # Determinant
	return atan2(det, dot) # atan2(y, x) or atan2(sin, cos). This will return an angle that will be positive for clockwise angles and negative for anticlockwise angles.

func _physics_process(delta):
	var player_mousevector = get_rotation_direction_component.globalGetRotationDirection()
	#check if forward_dir is close to player_mousevector
	#return out of function if ranged_weapons_dir is already close to player_mousevector
	var vectordiff: Vector3 = player_mousevector.normalized() - Vector3(ranged_weapons_dir.x, 0, ranged_weapons_dir.y).normalized()
	if -rotationclampfloat < vectordiff.x and  vectordiff.x < rotationclampfloat and -rotationclampfloat < vectordiff.z and vectordiff.z < rotationclampfloat:
		return
	
	#get clockwise angle between two vectors
	var angle: float = _CalculateAngleBetweenVectors(Vector2(player_mousevector.x, player_mousevector.z), ranged_weapons_dir)
	if angle >= 0:
		#rotate clockwise
		ranged_weapons_dir = _RotateVector(ranged_weapons_dir, (-ranged_rotation_speed * delta))
	if angle < 0:
		#rotate counterclockwise
		ranged_weapons_dir = _RotateVector(ranged_weapons_dir, (ranged_rotation_speed * delta))
	#set ranged_weapons_dir magnitude to be equal to player_mousevector
	ranged_weapons_dir = ranged_weapons_dir.normalized() * (player_mousevector.length())
	DebugOverlay.draw.add_vector(owner.position, owner.position + Vector3(ranged_weapons_dir.x, 0, ranged_weapons_dir.y), 2, Color.DARK_GREEN, false)
	#iterate through all children of ranged_weapons, and set their direction to be the ranged weapons dir
	for child in ranged_weapons.get_children():
		child.look_at(owner.position + Vector3(ranged_weapons_dir.x, 0, ranged_weapons_dir.y), Vector3.UP)
		DebugOverlay.draw.add_vector(child.global_position, child.global_position - child.get_global_transform().basis.z, 2, Color.CORNFLOWER_BLUE, false)
	
	#check if first child is looking in direction of ranged_weapons_dir
	vectordiff = Vector3(ranged_weapons_dir.x, 0, ranged_weapons_dir.y).normalized() + ranged_weapons.get_child(0).get_global_transform().basis.z
	if -rotationclampfloat < vectordiff.x and  vectordiff.x < rotationclampfloat and -rotationclampfloat < vectordiff.z and vectordiff.z < rotationclampfloat:
		return
	for child in ranged_weapons.get_children():
		child.look_at(owner.position + Vector3(ranged_weapons_dir.x, 0, ranged_weapons_dir.y), Vector3.UP)


