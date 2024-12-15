extends CreatureManaComponent

func InitMana(_mana):
	max_mana = _mana
	if PlayerResources.fresh_player:
		mana = max_mana
	else:
		mana = PlayerResources.mana
	mana_bar.globalInitMana(mana, max_mana)
