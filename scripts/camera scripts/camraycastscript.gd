extends RayCast3D
@onready var player = $"../../.."

func _process(_delta):
	var col = get_collider()
	if col.is_in_group("VisualObstruction"):
		var collidercolor: Color = col.get_node("arenawallmesh").get_active_material(0).albedo_color
		col.get_node("arenawallmesh").get_active_material(0).albedo_color = Color(collidercolor.r, collidercolor.g, collidercolor.b, .5)
