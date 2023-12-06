extends Node

@onready var attributes = get_parent().find_child("Attributes")
@onready var entity = attributes.entity
var entity_instance

func _spawn_enemy():
	entity_instance = entity.instantiate()
	get_tree().current_scene.add_child(entity_instance)
	entity_instance.position = owner.position


func _on_spawn_delay_timeout():
	_spawn_enemy()
