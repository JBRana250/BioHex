extends CreatureColBoxScript

#override parent's variable values
func _ready():
	health = 150

func globalOnHit(damage):
	health -= damage
	for child in cellpart.get_children():
		if child is MeshInstance3D:
			child.set_surface_override_material(0, onHitMaterial)
			await(_wait(0.05))
			child.set_surface_override_material(0, null)
	if health <= 0:
		for child in owner.get_children():
			if child.name == "Components":
				if child.find_child("PlayerDeathComponent"):
					child.find_child("PlayerDeathComponent").PlayerDeath()
				else:
					print("No Player Death Component!")
