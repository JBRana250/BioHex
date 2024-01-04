extends Node

class_name CreatureForceScript

@onready var movement_component = owner.find_child("MovementComponent")

var damping: float = 1

var forces: Dictionary = {}

class Force:
	var direction: Vector3
	var magnitude: float
	var duration: float
	func _init(_direction, _magnitude, _duration):
		direction = _direction
		magnitude = _magnitude
		duration = _duration

#Add a force to the entire creature (ignoring torque)
func globalAddForce(force_name, force_dir, force_mag, force_duration):
	forces[force_name] = Force.new(force_dir, force_mag, force_duration)

func _add_active_forces():
	for force_name in forces.keys():
		movement_component.globalAddActiveForce(force_name, forces[force_name].direction, forces[force_name].magnitude)

func _dampen_forces():
	for force_name in forces.keys():
		forces[force_name].duration -= 1
		if forces[force_name].duration < 0:
			forces.erase(force_name)

#Every physics process frame, reduce the magnitude of each force. If the magnitude is <= 0, remove the force from the list of forces acting on the creature.
func _physics_process(_delta):
	_add_active_forces()
	_dampen_forces()
