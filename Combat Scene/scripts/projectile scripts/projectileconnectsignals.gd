extends RigidBody3D

signal _body_shape_entered(body_rid, body, body_shape_index, local_shape_index)

func _ready():
	var ProjectileDamageComponent = find_child("ProjectileDamageComponent")
	_body_shape_entered.connect(ProjectileDamageComponent._on_body_shape_entered)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	_body_shape_entered.emit(body_rid, body, body_shape_index, local_shape_index)
