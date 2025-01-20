extends Button

@export var current_mode: String = "Buy"
@export var mode_on_press: String = "Sell"

func _on_pressed():
	var previous_mode = current_mode
	current_mode = mode_on_press
	mode_on_press = previous_mode
	
	owner.current_mode = current_mode
	text = mode_on_press
	
	owner._switch_display()
