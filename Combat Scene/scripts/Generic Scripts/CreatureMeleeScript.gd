extends CreatureAttackScript

var body_in_area = false

var damage_interval_finished = true
var body_shape

var overlapping_body_shapes = {}

var kb_mag: float = 25

#cool internet method but modified slightly
func _clean_dict(dirty_dict: Dictionary) -> Dictionary:
	var clean_dict := {}
	for key in dirty_dict:
		if is_instance_valid(key):
			var value = dirty_dict[key]
			clean_dict[key] = value
	return clean_dict


func _wait(seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await(t.timeout)
	damage_interval_finished = true
	return

func globalSetDamage(newDamage):
	damage = newDamage

func _on_body_shape_entered(_body_rid, body, body_shape_index, _local_shape_index):
	if !is_instance_valid(body):
		return
	if body.is_in_group(owner_alignment):
		return
	body_in_area = true
	body_shape = _get_body_shape_from_index(body, body_shape_index)
	overlapping_body_shapes[body_shape] = [body, body_shape_index]
	while(body_in_area and damage_interval_finished):
		if !is_instance_valid(body_shape) or !is_instance_valid(body):
			return
		if body_shape.get_child_count() != 0:
			
			body_shape.get_child(0).globalOnHit(damage, "melee_kb", owner.get_global_transform().basis.z, kb_mag, 0)
			damage_interval_finished = false
		await(_wait(0.1))

func _on_body_shape_exited(_body_rid, body, body_shape_index, _local_shape_index):
	if !is_instance_valid(body):
		return
	if body.is_in_group(owner_alignment):
		return
	body_shape = _get_body_shape_from_index(body, body_shape_index)
	#clean up array
	overlapping_body_shapes.erase(body_shape)
	overlapping_body_shapes = _clean_dict(overlapping_body_shapes)
	if overlapping_body_shapes == {}:
		body_in_area = false
	else:
		var current_body_shape_info = overlapping_body_shapes[overlapping_body_shapes.keys()[0]]
		var current_body = current_body_shape_info[0]
		var current_body_shape_index = current_body_shape_info[1]
		_on_body_shape_entered(_body_rid, current_body, current_body_shape_index, _local_shape_index)
