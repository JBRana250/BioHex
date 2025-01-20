extends Node

class_name creature_spawn_script 

# This is only to be used as a base class. Use the children of this class (SpawnEnemy and SpawnPlayer) instead

@export var base_damage: float = 5
@export var base_mana: float = 100

@export var creature_resource: Creature_Resource
@onready var character = creature_resource.character
@onready var body = creature_resource.body
@onready var components = creature_resource.components

const creature_spawn_beam = preload("res://Combat Scene/scenes/creaturespawnbeam.tscn")
const creature_transform_basis = preload("res://CreatureParts/creature_transform_basis.tscn")
const creature_action_timer = preload("res://CreatureParts/creature_action_timer.tscn")
const creature_spawn_particles = preload("res://Combat Scene/scenes/particle scenes/CreatureSpawnParticles.tscn")
const health_bar = preload("res://Combat Scene/scenes/bars/health_bars/health_bar.tscn")
const mana_bar = preload("res://Combat Scene/scenes/bars/mana_bars/mana_bar.tscn")

var creature_transform_basis_instance: Node3D
var body_instance: Node3D
var creature_action_timer_instance: Timer
var character_instance: CharacterBody3D
var components_instance: Node
var force_component_instance: Node
var health_component_instance: Node
var mana_component_instance: Node
var damage_component_instance: Node
var death_component_instance: Node
var spawn_particles_instance: Node3D
var health_bar_instance: Node3D
var mana_bar_instance: Node3D
var melee_weapons_instance: Node3D
var ranged_weapons_instance: Node3D
var dependency_component_instance: Node

var component_reference_parts: Array = []

func _wait(seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await(t.timeout)
	return

func _spawn_thing(_thing, _parent, _position, _rotation):
	if !_thing:
		print_debug("thing that is trying to be spawned does not exist")
		return
	var thing_instance = _thing.instantiate()
	if thing_instance.get_class() == "Node" or thing_instance.get_class() == "Timer":
		_parent.add_child(thing_instance)
		return thing_instance
	_parent.add_child(thing_instance)
	thing_instance.position = _position
	thing_instance.rotation = _rotation
	return thing_instance

func _attach_components():
	components_instance = components.instantiate()
	for component in components_instance.get_children():
		if "creature" in component:
			component.creature = character_instance
	character_instance.add_child(components_instance)

func _get_number_sign(number):
	if number > 0:
		return "POS"
	if number < 0:
		return "NEG"
	if number == 0:
		return "ZERO"
	else:
		print_debug("error getting sign")
		return "ERR"

func _unpack_cell_position(cell_pos: Vector2) -> Vector3:
	var unpacked_y_position = cell_pos.y * -1.7
	var unpacked_x_position: float = 0
	var step: float
	if int(cell_pos.x) & 1: # if odd
		unpacked_y_position += -0.85
		match _get_number_sign(cell_pos.x):
			"POS":
				unpacked_x_position += 1.5
				step = ceil(cell_pos.x / 2)
				unpacked_x_position += (cell_pos.x - step) * 3
			"NEG":
				unpacked_x_position -= 1.5
				step = floor(cell_pos.x / 2)
				unpacked_x_position += (cell_pos.x - step) * 3
	else: # if even
		match _get_number_sign(cell_pos.x):
			"POS":
				step = cell_pos.x / 2
				unpacked_x_position = (cell_pos.x - step) * 3
			"NEG":
				step = cell_pos.x / 2
				unpacked_x_position = (cell_pos.x - step) * 3
	return Vector3(unpacked_x_position, 0, unpacked_y_position)

func _spawn_creature():
	# Instantiate base creature
	character_instance = _spawn_thing(character, get_tree().current_scene, owner.position, Vector3())
	
	# Instantiate body
	body_instance = _spawn_thing(body, character_instance, Vector3(), Vector3())
	ranged_weapons_instance = body_instance.get_node("RangedWeapons")
	melee_weapons_instance = body_instance.get_node("MeleeWeapons")
	
	# Instantiate transform basis and action timer
	creature_transform_basis_instance = _spawn_thing(creature_transform_basis, get_tree().current_scene, Vector3(), Vector3())
	creature_action_timer_instance = _spawn_thing(creature_action_timer, character_instance, Vector3(), Vector3())
	
	# Instantiate Health and Mana bars
	health_bar_instance = _spawn_thing(health_bar, character_instance, Vector3(0,1,0), Vector3())
	mana_bar_instance = _spawn_thing(mana_bar, character_instance, Vector3(0,0.7,0), Vector3())

	# Iterate over creature_data, for each cell in creature data, instantiate it according to position.
	for cell in creature_resource.creature_data_array:
		# Instantiate cell at location
		var cell_pos = _unpack_cell_position(cell.position)
		var scene_resource = cell.scene_resource
		var cell_instance = _spawn_thing(scene_resource.scene, body_instance, cell_pos, Vector3())
		var CBcell_instance = _spawn_thing(scene_resource.CBscene, character_instance, cell_pos, Vector3(deg_to_rad(90),deg_to_rad(-30),0))
		var collision_component = CBcell_instance.get_child(0)
		
		collision_component.creature = character_instance
		component_reference_parts.append(collision_component)
		
		collision_component.cellpart = cell_instance
		
		if collision_component.is_core:
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
					var core_component_instance = _spawn_thing(scene_resource.scene, ranged_weapons_instance, temp_position_vector, Vector3())
					var CBcore_component_instance = _spawn_thing(scene_resource.CBscene, character_instance, temp_position_vector, Vector3())
					collision_component = CBcore_component_instance.get_child(0)
					collision_component.cellpart = core_component_instance
					
					# set damage attributes
					var damage_component = core_component_instance.get_node("Components").get_node("RangedDamageComponent")
					damage_component.damage = core_component.damage_resource.base_damage
					damage_component.owner_alignment = creature_resource.owner_alignment
			collision_component.creature = character_instance
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
					var outer_component_instance = _spawn_thing(scene_resource.scene, melee_weapons_instance, outer_component_pos, outer_component_rotation)
					var CBouter_component_instance = _spawn_thing(scene_resource.CBscene, character_instance, outer_component_pos, outer_component_rotation)
					collision_component = CBouter_component_instance.get_child(0)
					collision_component.cellpart = outer_component_instance
					var damage_component = outer_component_instance.find_child("Components").get_node("MeleeDamageComponent")
					damage_component.damage = outer_component.damage_resource.base_damage
					damage_component.owner_alignment = creature_resource.owner_alignment
					damage_component.character_instance = character_instance
					component_reference_parts.append(damage_component)
			collision_component.creature = character_instance
			component_reference_parts.append(collision_component)

func _spawn_beam():
	var beam_instance = _spawn_thing(creature_spawn_beam, get_tree().current_scene, owner.position + Vector3(0,20,0), Vector3())
	for i in range(17):
		beam_instance.scale.y += 5
		await(_wait(0.01))
	beam_instance.queue_free()
	spawn_particles_instance = _spawn_thing(creature_spawn_particles, get_tree().current_scene, owner.position, Vector3())
	spawn_particles_instance.get_child(0).emitting = true

func _calculate_health(cell_count):
	if cell_count == 1:
		return 12
	
	return (_calculate_health(cell_count - 1) + (cell_count - 1))

func _get_base_health():
	var num_of_cells = len(creature_resource.creature_data_array)
	var base_health = _calculate_health(num_of_cells)
	return base_health

func _attach_component_dependencies():
	character_instance.Dependencies["body"] = body_instance
	character_instance.Dependencies["creature_transform_basis"] = creature_transform_basis_instance
	character_instance.Dependencies["melee_weapons"] = melee_weapons_instance
	character_instance.Dependencies["ranged_weapons"] = ranged_weapons_instance
	character_instance.Dependencies["health_bar"] = health_bar_instance
	character_instance.Dependencies["mana_bar"] = mana_bar_instance

func _attach_part_dependencies():
	character_instance.Dependencies["force_component"] = components_instance.force_component
	character_instance.Dependencies["health_component"] = components_instance.health_component
	character_instance.Dependencies["mana_component"] = components_instance.mana_component
	character_instance.Dependencies["death_component"] = components_instance.death_component
	character_instance.Dependencies["on_deal_damage_component"] = components_instance.on_deal_damage_component

func _on_spawn_delay_timeout():
	health_component_instance = components_instance.health_component
	mana_component_instance = components_instance.mana_component
	damage_component_instance = components_instance.damage_component
	
	_attach_part_dependencies()
	for part in component_reference_parts:
		part._attach_dependencies()
	
	health_component_instance.health_bar = health_bar_instance
	mana_component_instance.mana_bar = mana_bar_instance
	
	health_component_instance.InitHealth(_get_base_health())
	mana_component_instance.InitMana(base_mana)
	damage_component_instance.InitDamage(base_damage)
	
	await(_wait(2.5))
	spawn_particles_instance.queue_free()
