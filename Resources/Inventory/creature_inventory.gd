extends Resource

class_name CreatureInventory

@export_group("Mods")
@export var damage_mods: Array[ModResource]
@export var speed_mods: Array[ModResource]
@export var rotation_speed_mods: Array[ModResource]
@export var defence_mods: Array[ModResource]
@export var core_defence_mods: Array[ModResource]
@export var max_health_mods: Array[ModResource]
@export var max_mana_mods: Array[ModResource]
@export var mana_efficiency_mods: Array[ModResource]
@export var max_mana_based_damage_mods: Array[ModResource]
@export var max_mana_percent_on_deal_damage_mods: Array[ModResource]
@export var max_mana_percent_on_kill_mods: Array[ModResource]
@export var combat_end_mana_recovery_percent_mods: Array[ModResource]
@export var combat_end_coin_gain_percent_mods: Array[ModResource]

@export_group("CombatResource")
@export var health: float
@export var mana: float
