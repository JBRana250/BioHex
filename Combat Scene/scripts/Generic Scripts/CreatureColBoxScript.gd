extends Node
class_name CreatureColBoxScript

var creature
var ForceComponent: Node
var HealthComponent: Node

@export var is_core: bool = false
var cellpart: Node3D

@onready var onHitMaterial = preload("res://Combat Scene/assets/Materials/creaturepartonhit.tres")

func _wait(seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await(t.timeout)
	return

func globalOnHit(damage, kb_force_name, kb_force_dir, kb_force_mag, kb_force_duration):
	if kb_force_mag > 0:
		ForceComponent.globalAddForce(kb_force_name, kb_force_dir, kb_force_mag, kb_force_duration)
	
	if !is_instance_valid(HealthComponent):
		return
	HealthComponent.globalDecreaseHealth(damage)
	
	if !is_instance_valid(cellpart):
		return
	
	for child in cellpart.get_children():
		if child is MeshInstance3D:
			child.set_surface_override_material(0, onHitMaterial)
			await(_wait(0.05))
			child.set_surface_override_material(0, null)
	
func _attach_dependencies():
	ForceComponent = creature.Dependencies["force_component"]
	HealthComponent = creature.Dependencies["health_component"]
	
