extends Node

#This script stores all data that is needed across scenes.

# Combat Scene Data
var camera: Camera3D
var player: CharacterBody3D

# World Scene Data
var path_map: Dictionary = {}
var rows_to_boss: int
var current_row: int = -1
var current_room_pos: Vector2

# Total rooms cleared across worlds
var rooms_cleared: int

# Evolution Scene Data
# camera ^
var active_cell_blueprint: Node3D

# For now, just set it as preloaded resource
@onready var player_creature_data: Resource = preload("res://Player/PlayerCreatureData.tres")
