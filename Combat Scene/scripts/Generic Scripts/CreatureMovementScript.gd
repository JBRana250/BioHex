extends Node
class_name CreatureMovementScript

var creature
@onready var creature_transform_basis: Node3D = creature.Dependencies["creature_transform_basis"]
@export var force_component: Node

@export var motion = Vector3()

@export var acceleration: float = 100
var base_accel: float

@export var deceleration: float = 100
var base_decel: float

@export var max_speed: float = 10
var base_speed: float

@export var movement_dir = Vector2()

@export var active_forces = {}
@export var net_active_force: Vector3

@export var creature_inventory: CreatureInventory
@export var stat_calculator: Node

class ActiveForce:
	var direction: Vector3
	var magnitude: float
	func _init(_direction, _magnitude):
		direction = _direction
		magnitude = _magnitude

func _ready():
	base_speed = max_speed
	base_accel = acceleration
	base_decel = deceleration
	
	_recalc_speed()

func _recalc_speed():
	if creature_inventory.speed_mods.is_empty():
		return
	
	max_speed = stat_calculator._calculate_speed(base_speed)
	var speed_difference = max_speed - base_speed
	
	acceleration = base_accel + (speed_difference * 10)
	deceleration = base_decel + (speed_difference * 10)

func globalSetMovementDirection(movement_direction):
	movement_dir = movement_direction

func globalAddActiveForce(force_name, force_dir, force_mag):
	active_forces[force_name] = ActiveForce.new(force_dir, force_mag)

func _sum_active_forces():
	for active_force in active_forces.values():
		net_active_force.x += active_force.direction.x * active_force.magnitude
		net_active_force.z += active_force.direction.y * active_force.magnitude

func _dampen_active_forces(delta):
	for active_force_name in active_forces.keys():
		active_forces[active_force_name].magnitude = move_toward(active_forces[active_force_name].magnitude, 0, deceleration * delta)
		if active_forces[active_force_name].magnitude <= 0:
			active_forces.erase(active_force_name)

func globalClearAllActiveForces():
	active_forces.clear()
	net_active_force = Vector3()

func _draw_movement_debug_overlay(direction):
	DebugOverlay.draw.add_vector(creature.position, creature.position + 3*creature_transform_basis.transform.basis.x, 1, Color.RED, false)
	DebugOverlay.draw.add_vector(creature.position, creature.position + 3*creature_transform_basis.transform.basis.y, 1, Color.GREEN, false)
	DebugOverlay.draw.add_vector(creature.position, creature.position + 3*creature_transform_basis.transform.basis.z, 1, Color.BLUE, false)
	DebugOverlay.draw.add_vector(creature.position, creature.position + 3*direction, 1, Color.MAGENTA, false)
	DebugOverlay.draw.add_vector(creature.position, creature.position + creature.velocity, 1, Color.BLACK, false)

func _physics_process(delta):
	var direction: Vector3 = (creature_transform_basis.transform.basis * Vector3(movement_dir.x, 0, movement_dir.y)).normalized()

	if direction == Vector3():
		motion = motion.move_toward(Vector3(), deceleration * delta)
	else:
		motion += (direction * acceleration * delta)
		motion = motion.limit_length(max_speed)
	
	_sum_active_forces()
	creature.velocity = motion + net_active_force
	_dampen_active_forces(delta)
	net_active_force = Vector3()
	
	_draw_movement_debug_overlay(direction)
	creature.move_and_slide()
