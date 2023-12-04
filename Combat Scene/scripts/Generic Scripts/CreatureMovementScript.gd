extends Node
class_name CreatureMovementScript

@export var xspeed: float = 5
@export var yspeed: float = 5
@export var acceleration: float = .5
@export var deceleration: float = .5

@export var max_speed: float = 10
@export var movement_dir = Vector2()

func globalSetMovementDirection(movement_direction):
	movement_dir = movement_direction

func _physics_process(_delta):
	var direction: Vector3 = (owner.transform.basis * Vector3(movement_dir.x, 0, movement_dir.y)).normalized()
	DebugOverlay.draw.add_vector(owner.position, owner.position + 3*owner.transform.basis.x, 1, Color.RED, false)
	DebugOverlay.draw.add_vector(owner.position, owner.position + 3*owner.transform.basis.y, 1, Color.GREEN, false)
	DebugOverlay.draw.add_vector(owner.position, owner.position + 3*owner.transform.basis.z, 1, Color.BLUE, false)
	DebugOverlay.draw.add_vector(owner.position, owner.position + 3*direction, 1, Color.MAGENTA, false)

	if direction.x != 0 and xspeed <= max_speed:
		xspeed += acceleration + deceleration #must add deceleration to counteract deceleration, since will be decelerating all the time
		owner.velocity.x = direction.x * xspeed
	else:
		owner.velocity.x -= owner.velocity.x * deceleration
	
	if direction.z != 0 and yspeed <= max_speed:
		yspeed += acceleration + deceleration
		owner.velocity.z = direction.z * yspeed
	else:
		owner.velocity.z -= owner.velocity.z * deceleration
		
	xspeed = clamp(xspeed, 1, max_speed - 1)
	yspeed = clamp(yspeed, 1, max_speed - 1)
	
	xspeed -= deceleration
	yspeed -= deceleration
	
	DebugOverlay.draw.add_vector(owner.position, owner.position + owner.velocity, 1, Color.BLACK, false)
	
	owner.move_and_slide()



