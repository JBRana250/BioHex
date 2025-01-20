extends CreatureHealthComponent

@export var player_inventory: PlayerInventory

func InitHealth(_health):
	max_health = _health
	max_health = stat_calculator._calculate_max_health(max_health)
	
	if player_inventory.fresh_player:
		health = max_health
	else:
		health = player_inventory.health
	
	defence = stat_calculator._calculate_defence(defence)
	
	health_bar.globalInitHealth(health, max_health)
