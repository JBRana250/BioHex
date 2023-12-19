extends Node

class_name creature_spawn_script

@onready var creature_data = get_parent().find_child("CreatureData")
@onready var creature_data_array = creature_data.creature_data_array
@onready var body = load("res://CreatureParts/body.tscn")

func _spawn_thing(_thing, _parent, _position, _rotation):
	if !_thing:
		print("thing that is trying to be spawned does not exist")
		return
	var thing_instance = _thing.instantiate()
	if thing_instance.get_class() == "Node":
		_parent.add_child(thing_instance)
		return thing_instance
	_parent.add_child(thing_instance)
	thing_instance.position = _position
	thing_instance.rotation = _rotation
	return thing_instance
	

func _on_spawn_delay_timeout():
	# Instantiate base template
	var template_instance = _spawn_thing(creature_data.template, get_tree().current_scene, owner.position, Vector3())
	
	# Instantiate body
	var body_instance = _spawn_thing(body, template_instance, template_instance.position, Vector3())
	
	# Iterate over creature_data, for each cell in creature data, instantiate it and all components within according to position.
	# Also instantiate the collision boxes for each part 
