extends Node

@export var player_inventory: PlayerInventory

@onready var string_to_modarray_dictionary: Dictionary = {
	"damage" : player_inventory.damage_mods,
	"speed" : player_inventory.speed_mods,
	"rotation_speed" : player_inventory.rotation_speed_mods,
	"defence" : player_inventory.defence_mods,
	"core_defence" : player_inventory.core_defence_mods,
	"max_health" : player_inventory.max_health_mods,
	"max_mana" : player_inventory.max_mana_mods,
	"mana_efficiency" : player_inventory.mana_efficiency_mods,
	"max_mana_based_damage" : player_inventory.max_mana_based_damage_mods,
	"max_mana_percent_on_deal_damage" : player_inventory.max_mana_percent_on_deal_damage_mods,
	"max_mana_percent_on_kill" : player_inventory.max_mana_percent_on_kill_mods,
	"combat_end_mana_recovery_percent" : player_inventory.combat_end_mana_recovery_percent_mods,
	"combat_end_coin_gain_percent" : player_inventory.combat_end_coin_gain_percent_mods
}

func _add_item_mods(item: ItemResource):
	for mod in item.mods:
		string_to_modarray_dictionary[mod.mod_type].append(mod)

func _remove_item_mods(item: ItemResource):
	for mod in item.mods:
		string_to_modarray_dictionary[mod.mod_type].erase(mod)

func _add_item(item: ItemResource):
	player_inventory.player_items.append(item)
	_add_item_mods(item)

func _remove_item(item: ItemResource):
	player_inventory.player_items.erase(item)
	_remove_item_mods(item)

func _print_mod_array(mod_array: Array[ModResource]):
	print_debug("start array")
	print()
	for mod in mod_array:
		print_debug(mod.mod_type)
		print_debug(mod.operation)
		print_debug(mod.value)
		print()
	print_debug("finish_array")
	print()
