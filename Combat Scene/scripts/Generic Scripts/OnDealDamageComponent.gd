extends Node

@export var creature_inventory: CreatureInventory
@export var stat_calculator: Node
@export var mana_component: Node

var gain_mana: bool = false

func _wait(seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await(t.timeout)
	return

func _ready():
	while creature_inventory == null:
		await(_wait(0.1))
	gain_mana = false
	if !creature_inventory.max_mana_percent_on_deal_damage_mods.is_empty():
		gain_mana = true

func _gain_mana():
	var max_mana_percent_gained = stat_calculator._calculate_max_mana_percent_on_deal_damage()
	var max_mana = stat_calculator._calculate_max_mana()
	var mana_gained = max_mana * (max_mana_percent_gained / 100)
	mana_component.globalIncreaseMana(mana_gained)

func globalDealDamage(_damage):
	if gain_mana:
		_gain_mana()
