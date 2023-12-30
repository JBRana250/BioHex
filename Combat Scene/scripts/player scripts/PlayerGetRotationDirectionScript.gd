extends GetRotationDirectionScript
var camera_3d: Camera3D

func _GetRotationDirection():
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var mousepos: Vector2 = get_viewport().get_mouse_position()

	var origin: Vector3 = camera_3d.project_ray_origin(mousepos)
	var end: Vector3 = origin + camera_3d.project_ray_normal(mousepos) * 1000
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = false
	query.collide_with_areas = true
	query.set_collision_mask(7)
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result.has("position"):
		var resultpos: Vector3 = result["position"]
		resultpos.y = resultpos.y * 0
		return resultpos
	return Vector3()
