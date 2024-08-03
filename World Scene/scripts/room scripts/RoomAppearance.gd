extends Node

@onready var attributes = get_parent().get_node("RoomAttributes")
@onready var room_mesh = owner.get_node("room_mesh")

func _ready():
	if attributes.eligible_to_travel:
		for room_mesh_child in room_mesh.get_children():
			for surface_override_material_index in range(room_mesh_child.get_surface_override_material_count()):
				var surface_override_material = room_mesh_child.get_surface_override_material(surface_override_material_index)
				var material_color = surface_override_material.albedo_color
				room_mesh_child.get_surface_override_material(surface_override_material_index).albedo_color = Color(material_color.r, material_color.g, material_color.b, 255)
