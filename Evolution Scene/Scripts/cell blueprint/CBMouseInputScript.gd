extends Node3D

@onready var camera_3d = Globals.camera
@export var mesh: MeshInstance3D
@export var properties: Node
@export var show_UI_component: Node
var mouse_hovering: bool = false
var is_active: bool = false

@export var mouse_entered_evo_ui: EventNoParam

func _ready():
	mouse_entered_evo_ui.connect("event_triggered", onMouseEnteredEvoUI)

func onMouseEnteredEvoUI():
	if is_active == false:
		mesh._set_material_idle()
	mouse_hovering = false

func onMouseEntered():
	if is_active == false:
		mesh._set_material_hover()
	mouse_hovering = true
	
func onMouseExited():
	if is_active == false:
		mesh._set_material_idle()
	mouse_hovering = false

func globalDeselectBlueprint():
	is_active = false
	mesh._set_material_idle()
	show_UI_component.globalHideUI()

func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		if mouse_hovering == true:
			var active_blueprint = Globals.active_cell_blueprint
			
			# if there is already an active blueprint:
			if active_blueprint != null:
				active_blueprint.show_UI_component.globalHideUI()
				active_blueprint.change_material_component._set_material_idle()
				active_blueprint.mouse_input_component.is_active = false
				
			mesh._set_material_active()
			show_UI_component.globalShowUI()
			is_active = true
			
			Globals.active_cell_blueprint = owner
