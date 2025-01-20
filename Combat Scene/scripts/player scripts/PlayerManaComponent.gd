extends CreatureManaComponent

#@export var creature_inventory: CreatureInventory
#@export var stat_calculator: Node

func InitMana(_mana):
	
	max_mana = stat_calculator._calculate_max_mana()
	
	if creature_inventory.fresh_player:
		mana = max_mana
	else:
		mana = creature_inventory.mana
		
	mana_efficiency = stat_calculator._calculate_mana_efficiency()
	
	mana_bar.globalInitMana(mana, max_mana)
