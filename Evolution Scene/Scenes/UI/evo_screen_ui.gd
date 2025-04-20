extends Control

@export var margin_container: MarginContainer
@export var display_vbox: VBoxContainer

@export var evo_ui_mouse_filter_change: EventWithParam

#func _ready():
	#evo_ui_mouse_filter_change.connect("event_triggered", blockMousePass)
	
#func blockMousePass(filter):
	#match filter:
		#"stop":
			#mouse_filter = MOUSE_FILTER_STOP
		#"pass":
			#mouse_filter = MOUSE_FILTER_PASS
		#_:
			#print_debug("unknown filter")
