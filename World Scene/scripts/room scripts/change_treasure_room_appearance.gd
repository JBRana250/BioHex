extends Node3D

func _change_treasure_color(color: Color):
	for child in get_children():
		if child.is_in_group("treasurebox"):
			for surface_override_material_index in range(child.get_surface_override_material_count()):
				var surface_override_material = child.get_surface_override_material(surface_override_material_index)
				surface_override_material.albedo_color = color

func _change_treasure_appearance(keys: int):
	match keys:
		1:
			_change_treasure_color(Color(0, 0, 0, 150/255.0))
		2:
			_change_treasure_color(Color(255/255.0, 150/255.0, 0, 75/255.0))
		3:
			_change_treasure_color(Color(0, 255/255.0, 255/255.0, 150/255.0)) 
