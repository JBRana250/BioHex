extends CreatureHealthComponent

func InitHealth(_health):
	max_health = _health
	if PlayerResources.fresh_player:
		health = max_health
	else:
		health = PlayerResources.health
	health_bar.globalInitHealth(health, max_health)
