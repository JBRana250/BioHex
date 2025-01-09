extends Node

var creature
@onready var cam_pivot: Node3D = creature.Dependencies["cam_pivot"]
@onready var creature_transform_basis: Node3D = creature.Dependencies["creature_transform_basis"]
@onready var spring_arm: SpringArm3D = creature.Dependencies["spring_arm"]
@onready var camera_3d: Camera3D = creature.Dependencies["camera_3d"]

func globalSetCameraDistance(distance):
	camera_3d.position.z = distance
	spring_arm.spring_length = distance
