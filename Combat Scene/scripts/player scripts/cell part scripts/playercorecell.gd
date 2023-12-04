extends CreatureColBoxScript

#override parent's variable values
func _ready():
	health = 150

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
		for child in owner.get_children():
			if child.name == "Components" and child.find_child("PlayerDeathComponent"):
				child.find_child("PlayerDeathComponent").PlayerDeath()
