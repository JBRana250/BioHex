extends Node

@export var template_res_path: String
@export var template: Resource

#References to cell part scenes:
@onready var basic_cell = preload("res://CreatureParts/CellParts/basiccell.tscn")
@onready var basic_cell_core = preload("res://CreatureParts/CellParts/basiccellcore.tscn")
@onready var basic_cell_caster = preload("res://CreatureParts/CellParts/basiccellcaster.tscn")
@onready var outer_nail = preload("res://CreatureParts/CellParts/outernail.tscn")

#References to cell part col box scenes:
@onready var basic_cell_CB = preload("res://CreatureParts/CellParts/CollisionBoxes/cellcolbox.tscn")
@onready var core_cell_CB = preload("res://CreatureParts/CellParts/CollisionBoxes/corecollisionbox.tscn")
@onready var basic_cell_caster_CB = preload("res://CreatureParts/CellParts/CollisionBoxes/cellcastercolbox.tscn")
@onready var outer_nail_CB = preload("res://CreatureParts/CellParts/CollisionBoxes/outernailcolbox.tscn")

#Express the creature as data

class Core:
	var Name: String
	var scene: Resource
	
	func _init(_name, _scene):
		Name = _name
		scene = _scene

class CoreComponent:
	var Name: String
	var type: String
	var core: Core
	var scene: Resource
	var CBscene: Resource
	
	func _init(_name, _type, _scene, _CBscene, _core):
		Name = _name
		type = _type
		core = _core
		scene = _scene
		CBscene = _CBscene

# position is an integer from 1 to 6. 1 means the component is in the positive z direction, going to 6 in the clockwize direction.

class InnerComponent:
	var Name: String
	var type: String
	var position: int
	var scene: Resource
	var CBscene: Resource
	
	func _init(_name, _type, _position, _scene, _CBscene):
		Name = _name
		type = _type
		position = _position
		scene = _scene
		CBscene = _CBscene

class OuterComponent:
	var Name: String
	var type: String
	var position: int
	var scene: Resource
	var CBscene: Resource
	
	func _init(_name, _type, _position, _scene, _CBscene):
		Name = _name
		type = _type
		position = _position
		scene = _scene
		CBscene = _CBscene

# Cell position is an int array. Every element dictates what direction the position of the cell steps in, and has the same rules as component positions. If position = null, the cell is at the origin

class Cell:
	var Name: String
	var position: Array
	var core_component: CoreComponent
	var inner_components: Array
	var outer_components: Array
	var scene: Resource
	var CBscene: Resource
	
	func _init(_name, _position, _core_component, _inner_componets, _outer_components, _scene, _CBscene):
		Name = _name
		position = _position
		core_component = _core_component
		inner_components = _inner_componets
		outer_components = _outer_components
		scene = _scene
		CBscene = _CBscene

var creature_data_array = []

func add_creature_data(new_data):
	creature_data_array.append(new_data)

func _ready():
	template = load(template_res_path)
	add_creature_data(Cell.new("core", [], null, [], [], basic_cell, core_cell_CB))
	add_creature_data(Cell.new("basic", [2], CoreComponent.new("basiccaster", "ranged_weapon", basic_cell_caster, basic_cell_caster_CB, Core.new("basiccore", basic_cell_core)), [], [], basic_cell, basic_cell_CB))
	add_creature_data(Cell.new("basic", [2,1], CoreComponent.new("basiccaster", "ranged_weapon", basic_cell_caster, basic_cell_caster_CB, Core.new("basiccore", basic_cell_core)), [], [OuterComponent.new("outernail", "melee_weapon", 1, outer_nail, outer_nail_CB)], basic_cell, basic_cell_CB))
	
