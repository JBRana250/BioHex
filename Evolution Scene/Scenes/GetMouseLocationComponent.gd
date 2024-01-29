extends Node3D
@export var camera_3d: Camera3D

var previous_hover_object: Node3D = null

var current_hover_object: Node3D:
	set(value):
		if value == null:
			callMouseExited(previous_hover_object)
		else:
			if value.is_in_group("CellBlueprint"):
				if value != previous_hover_object:
					callMouseExited(previous_hover_object)
				callMouseEntered(value)
				previous_hover_object = value
		

func _try_get_node(parent, node_name: String):
		if parent != null:
			var node = parent.get_node(node_name)
			return node
		else:
			return null

func callMouseEntered(object):
	var Components = _try_get_node(object, "Components")
	var MouseInputComponent = _try_get_node(Components, "MouseInputComponent")
	if MouseInputComponent != null:
		MouseInputComponent.globalMouseEntered()

func callMouseExited(object):
	var Components = _try_get_node(object, "Components")
	var MouseInputComponent = _try_get_node(Components, "MouseInputComponent")
	if MouseInputComponent != null:
		MouseInputComponent.globalMouseExited()

func _get_mouse_intersection():
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var mousepos: Vector2 = get_viewport().get_mouse_position()

	var origin: Vector3 = camera_3d.project_ray_origin(mousepos)
	var end: Vector3 = origin + camera_3d.project_ray_normal(mousepos) * 1000
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = false
	query.collide_with_areas = true
	var result: Dictionary = space_state.intersect_ray(query)
	
	if "collider" in result:
		current_hover_object = result["collider"].owner
	else:
		current_hover_object = null

func _input(_event):
	_get_mouse_intersection()
