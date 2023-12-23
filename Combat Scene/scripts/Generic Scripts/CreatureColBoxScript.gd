extends Node
class_name CreatureColBoxScript

var cellpart: Node3D
var health: float
@onready var onHitMaterial = preload("res://Combat Scene/assets/Materials/creaturepartonhit.tres")
@onready var cellPartDestructionParticles = preload("res://Combat Scene/scenes/particle scenes/CellPartDestruction.tscn")

func _wait(seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await(t.timeout)
	return

func _emit_death_particles(part):
	#instantiate particle system
	var particle_instance = cellPartDestructionParticles.instantiate()
	
	#set particle system's parent to be the world
	get_tree().current_scene.add_child(particle_instance)
	
	#set position of particle instance
	particle_instance.global_position = part.global_position
	
	#start the particle generation
	particle_instance.get_child(0).emitting = true
	
	#after 0.5s, queue free the particle instance
	await(_wait(0.5))
	particle_instance.queue_free()

func globalOnHit(damage):
	health -= damage
	if health <= 0:
		
		_emit_death_particles(cellpart)
		
		#queue free the cell part and the col box
		cellpart.queue_free()
		get_parent().queue_free()
		
	for child in cellpart.get_children():
		if child is MeshInstance3D:
			child.set_surface_override_material(0, onHitMaterial)
			await(_wait(0.05))
			child.set_surface_override_material(0, null)
