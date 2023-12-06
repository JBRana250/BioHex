extends Node

func _on_projectile_duration_timer_timeout():
	owner.queue_free() #destroys projectile after timer runs out
