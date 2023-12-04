extends Node

#This script stores all data that is needed across scenes.

var camera: Camera3D = null
var player: CharacterBody3D = null

var path_map: Dictionary = {}
var rows_to_boss: int
var current_row: int
var current_room_pos: Vector2
