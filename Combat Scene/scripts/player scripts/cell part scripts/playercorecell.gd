extends CreatureColBoxScript

var Components: Node

func _health_depleted():
	Components.get_node("PlayerDeathComponent").Death()
