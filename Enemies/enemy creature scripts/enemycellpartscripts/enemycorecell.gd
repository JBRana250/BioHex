extends CreatureColBoxScript

#var creature
var death_component: Node

func _attach_dependencies():
	super()
	death_component = creature.Dependencies["death_component"]

func _health_depleted():
	death_component.Death()
