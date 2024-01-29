extends Node

func _ready():
	EventManager.subscribe("LeavingScene", clean_UI)

func clean_UI(_event_data):
	for child in owner.get_children():
		if child is Control:
			child.queue_free()
