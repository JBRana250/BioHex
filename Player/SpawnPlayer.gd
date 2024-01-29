extends creature_spawn_script

var cam_pivot_instance: Node3D
@onready var cam_pivot = preload("res://Player/camera_pivot.tscn")
@onready var cam_pivot_remote = preload("res://Player/camera_pivot_remote.tscn")

var cam_lerp_weight = 5

func _wait(seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await(t.timeout)
	return

func _ready():
	DependencyArray = ["cam_pivot", "spring_arm", "camera_3d", "creature_transform_basis", "creature_action_timer"]
	await(get_tree().current_scene.tree_exited) #this is so that we wait for the old scene to unload
	cam_pivot_instance = _spawn_thing(cam_pivot, get_tree().current_scene, Vector3(), Vector3(deg_to_rad(-60), 0, 0))
	for i in range(50):
		cam_pivot_instance.position = cam_pivot_instance.position.lerp(owner.position, cam_lerp_weight * get_process_delta_time())
		await(_wait(0.01))

func _attach_dependencies(component, Dependency):
	match Dependency:
		"cam_pivot":
			component.cam_pivot = cam_pivot_instance
		"spring_arm":
			component.spring_arm = cam_pivot_instance.get_child(0)
		"camera_3d":
			component.camera_3d = cam_pivot_instance.get_child(0).get_child(0)
		"creature_transform_basis":
			component.creature_transform_basis = creature_transform_basis_instance
		"creature_action_timer":
			component.creature_action_timer = creature_action_timer_instance

func _check_dependencies(component):
	for Dependency in DependencyArray:
		if Dependency in component:
			_attach_dependencies(component, Dependency)

func _attach_camera():
	# Attach camera to base creature
	var cam_pivot_remote_instance = _spawn_thing(cam_pivot_remote, character_instance, Vector3(), Vector3())
	cam_pivot_remote_instance.remote_path = "../../CameraPivot"
	
func _on_spawn_delay_timeout():
	await(_spawn_beam())
	_spawn_creature()
	await(_attach_camera())
	_attach_components()
	force_component_instance = components_instance.find_child("ForceComponent")
	for part in component_reference_parts:
		_check_component_references(part)
	await(_wait(2.5))
	spawn_particles_instance.queue_free()
