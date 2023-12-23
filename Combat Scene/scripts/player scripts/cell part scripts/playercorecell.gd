extends CreatureColBoxScript

var Components: Node

func globalOnHit(damage):

	if !is_instance_valid(cellpart):
		return
	health -= damage
	for child in cellpart.get_children():
		if !is_instance_valid(child) or !child is MeshInstance3D:
			return
		child.set_surface_override_material(0, onHitMaterial)
		await(_wait(0.05))
		if is_instance_valid(child):
			child.set_surface_override_material(0, null)

	if health <= 0:
		Components.get_node("PlayerDeathComponent").PlayerDeath(Components.get_parent())
