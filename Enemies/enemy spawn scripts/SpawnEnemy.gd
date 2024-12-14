extends creature_spawn_script

func _on_spawn_delay_timeout():
	await(_spawn_beam())
	_spawn_creature()
	_attach_component_dependencies()
	_attach_components()
	super() #calls original function in base class creature_spawn_script
