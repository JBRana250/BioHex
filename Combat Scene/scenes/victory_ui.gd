extends Control

const resource_gained_ui = preload("res://Combat Scene/scenes/ResourceGained.tscn")
@export var stuff_gained_ui: HFlowContainer
@export var resources_gained: Dictionary

func globalShowVictoryUI():
	var amount_gained = 0
	for resource in resources_gained.keys():
		amount_gained = resources_gained[resource]
		if amount_gained != 0:
			var resgained_instance = resource_gained_ui.instantiate()
			stuff_gained_ui.add_child(resgained_instance)
			resgained_instance.amount_gained = amount_gained
			resgained_instance.resource_gained = resource
			resgained_instance.globalShowResourcesGained()
	visible = true
