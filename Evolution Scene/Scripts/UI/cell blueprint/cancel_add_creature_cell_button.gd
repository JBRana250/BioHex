extends TextureButton

func _on_pressed():
	Globals.active_cell_blueprint.get_node("Components").get_node("MouseInputComponent").globalDeselectBlueprint()
	Globals.active_cell_blueprint = null
