extends Node

var creature
@onready var ranged_weapons = creature.Dependencies["ranged_weapons"]
@export var mana_component: Node

const basic_bullet = preload("res://Combat Scene/scenes/projectiles/basicprojectile.tscn")

@export var firing: bool = false
var bullet_speed: float = 1500

func globalSetFiring(isFiring):
	firing = isFiring

func _reload_completed(weapon):
	if weapon.find_children("", "Timer") == []:
		print_debug("weapon has no Timer child!")
	else:
		if weapon.find_children("", "Timer")[0].is_stopped() == true:
			return true
		return false

func _fire_weapon(weapon):
	if _reload_completed(weapon) == false:
		return
	if mana_component.mana <= 0:
		return
	var projectile_instance = basic_bullet.instantiate()
	
	#set bullet's parent to be the world
	get_tree().current_scene.add_child(projectile_instance)
	
	#set bullet's position
	if weapon.find_children("", "Marker3D") == []:
		print_debug("weapon has no Marker3D child!")
		projectile_instance.position = weapon.global_position + Vector3(creature.velocity.x, 0, creature.velocity.z) * 0.025
	else:
		projectile_instance.position = weapon.find_children("", "Marker3D")[0].global_position + Vector3(creature.velocity.x, 0, creature.velocity.z) * 0.025
	
	#set bullet direction and speed
	var weapon_dir = -weapon.get_global_transform().basis.z
	projectile_instance.look_at(weapon_dir, Vector3.UP)
	var ProjectileMovementComponent = projectile_instance.find_child("ProjectileMovementComponent")
	var ProjectileDamageComponent = projectile_instance.find_child("ProjectileDamageComponent")
	var RangedDamageComponent = weapon.find_child("RangedDamageComponent")
	
	ProjectileMovementComponent.direction = weapon_dir
	ProjectileMovementComponent.bullet_speed = bullet_speed
	
	ProjectileDamageComponent.damage = RangedDamageComponent.damage
	ProjectileDamageComponent.owner_alignment = RangedDamageComponent.owner_alignment
	
	mana_component.globalDecreaseMana(2.5)
	
	weapon.find_children("", "Timer")[0].start()

func _process(_delta):
	if(firing):
		#iterate through all shooters on player
		for weapon in ranged_weapons.get_children():
			_fire_weapon(weapon)
