extends Control

@export var keys_needed: int
@export var label_keys_needed: Label
@export var label_keys_have: Label

func _assign_key_labels():
	label_keys_needed.text = "Need {keys} Key(s)".format({"keys":keys_needed})
	label_keys_have.text = "Have {keys} Key(s)".format({"keys":PlayerResources.keys})
