extends CreatureColBoxScript

#var creature
var death_component: Node
var health: float
var defence: float = 1

@export var stat_calculator: Node

func _ready():
	defence = stat_calculator._calculate_core_defence(defence)

func _attach_dependencies():
	super()
	death_component = creature.Dependencies["death_component"]

func globalOnHit(damage, kb_force_name, kb_force_dir, kb_force_mag, kb_force_duration):
	super(damage, kb_force_name, kb_force_dir, kb_force_mag, kb_force_duration)
	health -= (damage - defence)
	if health <= 0:
		_health_depleted()

func _health_depleted():
	death_component.Death()
