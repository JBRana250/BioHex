extends Node

# This is a component of the UI autoload, it is NOT an autoload in and of itself

@export var leaving_scene: Event

func _ready():
	leaving_scene.connect("event_triggered", clean_UI)

func clean_UI():
	for child in owner.get_children():
		if child is Control:
			child.queue_free()
