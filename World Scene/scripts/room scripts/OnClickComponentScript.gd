extends Node

class_name OnClickComponentScript 

# Use only as a base class. Use "NewSceneOnClick.gd" or "UIDisplayOnClick.gd" instead.

@export var attributes: Node

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	Globals.rooms_cleared += 1
