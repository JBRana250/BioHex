extends creature_spawn_script

var cam_pivot_instance: Node3D

func _ready():
	await(get_tree().current_scene.tree_exited) #this is so that we wait for the old scene to unload
	var cam_pivot = load("res://Player/camera_pivot.tscn")
	cam_pivot_instance = _spawn_thing(cam_pivot, get_tree().current_scene, Vector3(), Vector3(deg_to_rad(-60), 0, 0))

func _attach_camera(character_instance):
	# Attach camera to base creature
	get_tree().current_scene.remove_child(cam_pivot_instance)
	character_instance.add_child(cam_pivot_instance)
	
func _on_spawn_delay_timeout():
	var character_instance = _spawn_creature()
	_attach_camera(character_instance)
	_attach_components(character_instance)
