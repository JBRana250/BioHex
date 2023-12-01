extends Node
@onready var cellPartDestructionParticles = preload("res://scenes/particle scenes/CellPartDestruction.tscn")

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

func EnemyDeath():
	for child in owner.find_child("Body").get_children():
		if child is Node3D:
			_emit_death_particles(child)
		
		#queue free the child
		child.queue_free()
		
	owner.queue_free()
