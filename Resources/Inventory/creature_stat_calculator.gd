extends Node

@export var creature_inventory: CreatureInventory
@export var initial_creature: InitialCreatureResource

func _calculate_stat(mod_array: Array[ModResource], initial_stat_value: float):
	
	for mod in mod_array:
		if mod.operation == "add":
			initial_stat_value += mod.value
	for mod in mod_array:
		if mod.operation == "mult":
			initial_stat_value *= mod.value
	
	return initial_stat_value

func _calculate_defence(defence_value):
	return _calculate_stat(creature_inventory.defence_mods, defence_value)

func _calculate_max_mana():
	return _calculate_stat(creature_inventory.max_mana_mods, initial_creature.initial_mana)

func _calculate_max_health(_health):
	return _calculate_stat(creature_inventory.max_health_mods, _health)

func _calculate_mana_efficiency():
	return _calculate_stat(creature_inventory.mana_efficiency_mods, 1)

func _calculate_combat_end_mana_recovery_percent():
	return _calculate_stat(creature_inventory.combat_end_mana_recovery_percent_mods, 0)

func _calculate_max_mana_based_damage():
	return _calculate_stat(creature_inventory.max_mana_based_damage_mods, 0)

func _calculate_max_mana_percent_on_kill():
	return _calculate_stat(creature_inventory.max_mana_percent_on_kill_mods, 0)

func _calculate_max_mana_percent_on_deal_damage():
	return _calculate_stat(creature_inventory.max_mana_percent_on_deal_damage_mods, 0)

func _calculate_damage():
	return _calculate_stat(creature_inventory.damage_mods, initial_creature.initial_damage)

func _calculate_speed(speed_value):
	return _calculate_stat(creature_inventory.speed_mods, speed_value)

func _calculate_core_defence(defence_value):
	var defence = _calculate_defence(defence_value)
	return _calculate_stat(creature_inventory.core_defence_mods, defence)

func _calculate_combat_end_coin_gain_percent():
	return _calculate_stat(creature_inventory.combat_end_coin_gain_percent_mods, 0)

func _calculate_rotation_speed(rotation_speed_value):
	return _calculate_stat(creature_inventory.rotation_speed_mods, rotation_speed_value)
