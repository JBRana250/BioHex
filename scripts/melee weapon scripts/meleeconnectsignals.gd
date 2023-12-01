extends Area3D

signal _body_shape_entered(body, body_shape_index)
signal _body_shape_exited

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	_body_shape_entered.emit(body_rid, body, body_shape_index, local_shape_index)


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	_body_shape_exited.emit(body_rid, body, body_shape_index, local_shape_index)

func _ready():
	var MeleeDamageComponent = find_child("MeleeDamageComponent")
	_body_shape_entered.connect(MeleeDamageComponent._on_body_shape_entered)
	_body_shape_exited.connect(MeleeDamageComponent._on_body_shape_exited)
