extends creature_spawn_script

var cam_pivot_instance: Node3D
var components_scene: Resource 

func _ready():
	await(get_tree().current_scene.tree_exited) #this is so that we wait for the old scene to unload
	components_scene = load("res://Player/components.tscn")
	var cam_pivot = load("res://Player/camera_pivot.tscn")
	
	cam_pivot_instance = _spawn_thing(cam_pivot, get_tree().current_scene, Vector3(), Vector3(deg_to_rad(-60), 0, 0))

func _on_spawn_delay_timeout():
	# Instantiate base template
	var template_instance = _spawn_thing(creature_data.template, get_tree().current_scene, owner.position, Vector3())
	
	# Attach camera to base template
	get_tree().current_scene.remove_child(cam_pivot_instance)
	template_instance.add_child(cam_pivot_instance)
	
	# Instantiate body
	var body_instance = _spawn_thing(body, template_instance, Vector3(), Vector3())
	var ranged_weapons = body_instance.find_child("RangedWeapons")
	var melee_weapons = body_instance.find_child("MeleeWeapons")
	
	# Iterate over creature_data, for each cell in creature data, instantiate it according to position.
	for cell in creature_data_array:
		# Instantiate cell at location
		# Figure out position
		var cell_pos = Vector3()
		for number in cell.position:
			match number:
				1:
					cell_pos.z += 1.7
				2:
					cell_pos.x += -1.5
					cell_pos.z += 0.85
				3:
					cell_pos.x += -1.5
					cell_pos.z += -0.85
				4:
					cell_pos.z += -1.7
				5:
					cell_pos.x += 1.5
					cell_pos.z += -0.85
				6:
					cell_pos.x += 1.5
					cell_pos.z += 0.85
		var cell_instance = _spawn_thing(cell.scene, body_instance, cell_pos, Vector3())
		var CBcell_instance = _spawn_thing(cell.CBscene, template_instance, cell_pos, Vector3(deg_to_rad(90),deg_to_rad(-30),0))
		
		#Instantiate core component of cell (if any)
		if cell.core_component:
			match cell.core_component.type:
				"ranged_weapon":
					# Will have to create an array with the relative position vectors for the other core components.
					# For now, just use a single temporary V3
					var temp_position_vector = Vector3(cell_pos.x, 1, cell_pos.z)
					var core_component_instance = _spawn_thing(cell.core_component.scene, ranged_weapons, temp_position_vector, Vector3())
					var CBcore_component_instance = _spawn_thing(cell.core_component.CBscene, template_instance, temp_position_vector, Vector3())
					
					# set damage attributes
					var damage_component = core_component_instance.find_child("Components").find_child("RangedDamageComponent")
					damage_component.damage = 2.5
					damage_component.owner_alignment = "Player"
					
		for inner_component in cell.inner_components:
			pass
			#no inner components for now
			
		for outer_component in cell.outer_components:
			var outer_component_pos = cell_pos
			var outer_component_rotation = Vector3()
			match outer_component.type:
				"melee_weapon":
					match outer_component.position:
						1:
							outer_component_pos.z += 1.1
							outer_component_rotation = Vector3()
						2:
							outer_component_pos.x += -0.93 
							outer_component_pos.z += 0.54
							outer_component_rotation = Vector3(0, deg_to_rad(300), 0)
						3:
							outer_component_pos.x += -0.93 
							outer_component_pos.z += -0.54
							outer_component_rotation = Vector3(0, deg_to_rad(240), 0)
						4:
							outer_component_pos.z += -1.1
							outer_component_rotation = Vector3(0, deg_to_rad(180), 0)
						5:
							outer_component_pos.x += 0.93 
							outer_component_pos.z += -0.54
							outer_component_rotation = Vector3(0, deg_to_rad(120), 0)
						6:
							outer_component_pos.x += 0.93 
							outer_component_pos.z += 0.54
							outer_component_rotation = Vector3(0, deg_to_rad(60), 0)
					var outer_component_instance = _spawn_thing(outer_component.scene, melee_weapons, outer_component_pos, outer_component_rotation)
					var damage_component = outer_component_instance.find_child("Components").find_child("MeleeDamageComponent")
					damage_component.damage = 0.5
					damage_component.owner_alignment = "Player"
					
	#Attach components to player
	var components_instance = _spawn_thing(components_scene, template_instance, Vector3(), Vector3())
