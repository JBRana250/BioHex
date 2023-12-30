extends Node
class_name CreatureAttackScript

@export var damage: float
@export var owner_alignment: String

var kb_force_dir: Vector3

func _get_body_shape_from_index(body, body_shape_index):
	var body_shape_owner = body.shape_find_owner(body_shape_index)
	return body.shape_owner_get_owner(body_shape_owner)

func _on_body_shape_entered(_body_rid, body, body_shape_index, _local_shape_index):
	if body.is_in_group(owner_alignment):
		return
	if !(body):
		return
	var body_shape = _get_body_shape_from_index(body, body_shape_index)
	if body_shape.get_child_count() != 0:
		body_shape.get_node("CreatureColComponent").globalOnHit(damage)
