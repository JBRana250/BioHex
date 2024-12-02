extends RoomAppearance
	
func _ready():
	
	match attributes.keys_needed:
		1:
			room_mesh._change_treasure_appearance(1)
		2:
			room_mesh._change_treasure_appearance(2)
		3:
			room_mesh._change_treasure_appearance(3)
	
	if attributes.eligible_to_travel:
		for room_mesh_child in room_mesh.get_children():
			for surface_override_material_index in range(room_mesh_child.get_surface_override_material_count()):
				var surface_override_material = room_mesh_child.get_surface_override_material(surface_override_material_index)
				var material_color = surface_override_material.albedo_color
				surface_override_material.albedo_color = Color(material_color.r, material_color.g, material_color.b, 255)
