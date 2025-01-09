extends UIDisplayOnClickScript

var already_assigned_keys: bool = false

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	super(_camera, event, _position, _normal, _shape_idx)
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("left_click") and attributes.eligible_to_travel and !already_assigned_keys:
			already_assigned_keys = true
			ui_instance.keys_needed = attributes.keys_needed
			ui_instance._assign_key_labels()
