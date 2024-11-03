extends Node2D


const SPAWN_ROOMS: Array = [preload("res://Scenes/spawn_room_0.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Scenes/room0.tscn"),preload("res://Scenes/room_1.tscn"),preload("res://Scenes/room_2.tscn")]
const END_ROOMS: Array = [preload("res://Scenes/end_room0.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 0
const RIGHT_WALL_TILE_INDEX: int = 1
const LEFT_WALL_TILE_INDEX: int = 1

@export var num_levels : int = 5

@onready var player: CharacterBody2D = get_parent().get_node("Player")

func _ready() -> void:
	_spawn_rooms()

func _spawn_rooms() -> void:
	var previous_room: Node2D
	
	for i in num_levels:
		var room: Node2D
		
		if i == 0:
			room = SPAWN_ROOMS.pick_random().instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
			
		add_child(room)
		previous_room = room
