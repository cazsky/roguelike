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
		else: 
			if i == num_levels - 1:
				room = END_ROOMS.pick_random().instantiate()
			else:
				room = INTERMEDIATE_ROOMS.pick_random().instantiate()
				
			var previous_room_tilemap: TileMapLayer = previous_room.get_node("FloorLayer")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2 = previous_room_tilemap.to_local(previous_room_door.position) + Vector2.UP * 2
			
			# Generate Corridor
			var corridor_height: int = randi_range(2,6)
			for y in corridor_height:
				# ???
				# Fix set_cell later
				previous_room_tilemap.set_cell(exit_tile_pos + Vector2(-2, -y), LEFT_WALL_TILE_INDEX)
				previous_room_tilemap.set_cell(exit_tile_pos + Vector2(-1, -y), FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cell(exit_tile_pos + Vector2(0, -y), FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cell(exit_tile_pos + Vector2(1, -y), RIGHT_WALL_TILE_INDEX)
				
			
		add_child(room)
		previous_room = room
