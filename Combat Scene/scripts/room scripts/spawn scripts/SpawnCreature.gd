extends Node

class_name creature_spawn_script

@export var creature_resource: Creature_Resource
@onready var character = creature_resource.character
@onready var body = creature_resource.body
@onready var components = creature_resource.components

const creature_transform_basis = preload("res://CreatureParts/creature_transform_basis.tscn")

var creature_transform_basis_instance: Node3D
var components_instance: Node
var force_component_instance: Node

#an array that contains all the creature parts which need a reference to the Components of the creature, since Components is instantiated after the creature.
var component_reference_parts = []

func _spawn_thing(_thing, _parent, _position, _rotation):
	if !_thing:
		print_debug("thing that is trying to be spawned does not exist")
		return
	var thing_instance = _thing.instantiate()
	if thing_instance.get_class() == "Node":
		_parent.add_child(thing_instance)
		return thing_instance
	_parent.add_child(thing_instance)
	thing_instance.position = _position
	thing_instance.rotation = _rotation
	return thing_instance

var DependencyArray = ["creature_transform_basis"]

func _attach_dependencies(component, Dependency):
	match Dependency:
		"creature_transform_basis":
			component.creature_transform_basis = creature_transform_basis_instance

func _check_dependencies(component):
	for Dependency in DependencyArray:
		if Dependency in component:
			_attach_dependencies(component, Dependency)

func _attach_components(_parent):
	var thing_instance = components.instantiate()
	for component in thing_instance.get_children():
		_check_dependencies(component)
	_parent.add_child(thing_instance)
	return thing_instance

func _spawn_creature():
	# Instantiate base creature
	var character_instance = _spawn_thing(character, get_tree().current_scene, owner.position, Vector3())
	
	# Instantiate body
	var body_instance = _spawn_thing(body, character_instance, Vector3(), Vector3())
	var ranged_weapons = body_instance.get_node("RangedWeapons")
	var melee_weapons = body_instance.get_node("MeleeWeapons")
	
	creature_transform_basis_instance = _spawn_thing(creature_transform_basis, get_tree().current_scene, Vector3(), Vector3())
	
	# Iterate over creature_data, for each cell in creature data, instantiate it according to position.
	for cell in creature_resource.creature_data_array:
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
		var scene_resource = cell.scene_resource
		var cell_instance = _spawn_thing(scene_resource.scene, body_instance, cell_pos, Vector3())
		var CBcell_instance = _spawn_thing(scene_resource.CBscene, character_instance, cell_pos, Vector3(deg_to_rad(90),deg_to_rad(-30),0))
		var collision_component = CBcell_instance.get_child(0)
		
		component_reference_parts.append(collision_component)
		
		collision_component.cellpart = cell_instance
		collision_component.health = float(cell.health_resource.base_health)
		
		#Instantiate core component of cell (if any)
		var core_component = cell.core_component
		if core_component:
			match core_component.type:
				"ranged_weapon":
					# Will have to create an array with the relative position vectors for the other core components.
					# For now, just use a single temporary V3
					var temp_position_vector = Vector3(cell_pos.x, 1, cell_pos.z)
					scene_resource = core_component.scene_resource
					var core_component_instance = _spawn_thing(scene_resource.scene, ranged_weapons, temp_position_vector, Vector3())
					var CBcore_component_instance = _spawn_thing(scene_resource.CBscene, character_instance, temp_position_vector, Vector3())
					collision_component = CBcore_component_instance.get_child(0)
					collision_component.cellpart = core_component_instance
					collision_component.health = float(core_component.health_resource.base_health)
					
					# set damage attributes
					var damage_component = core_component_instance.get_node("Components").get_node("RangedDamageComponent")
					damage_component.damage = 2.5
					damage_component.owner_alignment = creature_resource.owner_alignment
			component_reference_parts.append(collision_component)
					
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
					scene_resource = outer_component.scene_resource
					var outer_component_instance = _spawn_thing(scene_resource.scene, melee_weapons, outer_component_pos, outer_component_rotation)
					var CBouter_component_instance = _spawn_thing(scene_resource.CBscene, character_instance, outer_component_pos, outer_component_rotation)
					collision_component = CBouter_component_instance.get_child(0)
					collision_component.cellpart = outer_component_instance
					collision_component.health = float(outer_component.health_resource.base_health)
					var damage_component = outer_component_instance.find_child("Components").get_node("MeleeDamageComponent")
					damage_component.damage = 0.5
					damage_component.owner_alignment = creature_resource.owner_alignment
			component_reference_parts.append(collision_component)
	return character_instance

var component_references = ["Components", "ForceComponent"]

func _attach_component_reference(part, comp_ref):
	match comp_ref:
		"Components":
			part.Components = components_instance
		"ForceComponent":
			part.ForceComponent = force_component_instance

func _check_component_references(part):
	for comp_ref in component_references:
		if comp_ref in part:
			_attach_component_reference(part, comp_ref)

func _on_spawn_delay_timeout():
	var character_instance = _spawn_creature()
	components_instance = _attach_components(character_instance)
	force_component_instance = components_instance.find_child("ForceComponent")
	for part in component_reference_parts:
		_check_component_references(part)
