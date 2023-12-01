extends Node3D

@export var damageDistance: String = "MeleeDamageComponent"
@export var alignment: String = "Enemy"
@export var damage: float = 0.5

func _ready():
	var damageComponent = find_child(damageDistance)
	damageComponent.owner_alignment = alignment
	damageComponent.globalSetDamage(damage)
