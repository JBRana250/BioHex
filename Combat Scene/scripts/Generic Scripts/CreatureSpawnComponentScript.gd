extends Node

class_name CreatureSpawnComponentScript

var creature
@onready var body = creature.Dependencies["body"]

const on_spawn_material = preload("res://Combat Scene/assets/Materials/creaturepartonhit.tres")
var creature_parts = []

func _wait(seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await(t.timeout)
	return

class mesh:
	var mesh_instance: MeshInstance3D
	var material: Material
	
	func _init(_mesh_instance):
		mesh_instance = _mesh_instance
		material = mesh_instance.get_active_material(0)

class creature_part:
	var part: Node3D
	var mesh_array = []
	
	func _get_mesh_in_part(_part):
		var _mesh_array = []
		for child in _part.get_children():
			if child is MeshInstance3D:
				_mesh_array.append(child)
		return _mesh_array
	
	func _init(_part):
		part = _part
		var meshes = _get_mesh_in_part(part)
		for _mesh in meshes:
			mesh_array.append(mesh.new(_mesh))

#func _set_mesh_color(_mesh, _color):
	#var material = StandardMaterial3D.new()
	#material.albedo_color = _color
	#_mesh.set_surface_override_material(0, material)

func _get_creature_parts():
	for child in body.get_children():
		match child.name:
			"MeleeWeapons":
				for melee_weapon in child.get_children():
					creature_parts.append(creature_part.new(melee_weapon))
			"RangedWeapons":
				for ranged_weapon in child.get_children():
					creature_parts.append(creature_part.new(ranged_weapon))
			_:
				creature_parts.append(creature_part.new(child))

func _set_initial_materials():
	for _creature_part in creature_parts:
		for _mesh in _creature_part.mesh_array:
			_mesh.mesh_instance.set_surface_override_material(0, on_spawn_material)

func _interpolate_materials():
	for i in range(20):
		for _creature_part in creature_parts:
			for _mesh in _creature_part.mesh_array:
				var current_material = _mesh.mesh_instance.get_active_material(0)
				var interp_material = StandardMaterial3D.new()
				#Interpolate from current_material's color and the mesh's inherent mesh.material color
				var interp_color = current_material.albedo_color.lerp(_mesh.material.albedo_color, 0.2)
				#Interpolate the emission color as well, from white to mesh's inherent emission
				var interp_emission = current_material.emission.lerp(_mesh.material.emission, 0.2)
				interp_material.albedo_color = interp_color
				interp_material.emission = interp_emission
				_mesh.mesh_instance.set_surface_override_material(0, interp_material)
				await(_wait(0.01))

func _reset_surface_override_materials():
	for _creature_part in creature_parts:
		for _mesh in _creature_part.mesh_array:
			_mesh.mesh_instance.set_surface_override_material(0, null)

func _ready():
	_get_creature_parts()
	_set_initial_materials()
	await(_interpolate_materials())
	_reset_surface_override_materials()
	
