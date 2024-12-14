extends Node2D


const SPAWN_ROOMS: Array = [preload("res://Scenes/Rooms/Child Rooms/spawn_room_0.tscn"),
preload("res://Scenes/Rooms/Child Rooms/spawn_room_1.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Scenes/Rooms/Child Rooms/room0.tscn"),
preload("res://Scenes/Rooms/Child Rooms/room_1.tscn"),
preload("res://Scenes/Rooms/Child Rooms/room_2.tscn")]
const END_ROOMS: Array = [preload("res://Scenes/Rooms/Child Rooms/end_room0.tscn")]
const SPECIAL_ROOMS: Array = [preload("res://Scenes/Rooms/Child Rooms/special_room_0.tscn")]
const BOSS_ROOMS: Array = [preload("res://Scenes/Rooms/Child Rooms/slug_boss_room.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: Vector2i = Vector2i(0,0)
const RIGHT_FLOOR_TILE_INDEX: Vector2i = Vector2i(5,5)
const LEFT_FLOOR_TILE_INDEX: Vector2i = Vector2i(4,5)
const WALL_TILE_INDEX: Vector2i = Vector2i(0,1)
const BOSS_LEVEL: int = 3 # Change this to set how many levels before boss

# Number of levels in a stage, cant set to 1 since the spawn room counts as 1
@export var num_levels : int = 5

@onready var player: CharacterBody2D = get_parent().get_node("Player")

func _ready() -> void:
	SavedData.num_floor += 1
	if SavedData.num_floor == BOSS_LEVEL:
		num_levels = 2
	_spawn_rooms()

func _spawn_rooms() -> void:
	var previous_room: Node2D = null
	var special_room_spawned: bool = false
	
	for i in num_levels:
		var room: Node2D
		
		if i == 0:
			room = SPAWN_ROOMS.pick_random().instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if SavedData.num_floor == BOSS_LEVEL:
				room = BOSS_ROOMS.pick_random().instantiate()
			else: 
				# If its the last level pick an end room
				if i == num_levels - 1:
					room = END_ROOMS.pick_random().instantiate()
				# If not first or last just choose a normal room
				else:
					if (randi_range(0, 3) == 0 or i == num_levels - 2) and not special_room_spawned:
						room = SPECIAL_ROOMS.pick_random().instantiate()
						special_room_spawned = true
					else:
						room = INTERMEDIATE_ROOMS.pick_random().instantiate()
				
			var previous_room_floor_tilemap: TileMapLayer = previous_room.get_node("MapLayer/FloorTextureLayer")
			var previous_room_wall_tilemap: TileMapLayer = previous_room.get_node("MapLayer/ObstacleLayer")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2i = previous_room_floor_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 2
			
			# Generate Corridor
			previous_room_floor_tilemap.navigation_enabled = false
			var corridor_height: int = randi_range(3,10)
			for y in range(-1, corridor_height + 1):
				# void set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0)
				previous_room_wall_tilemap.set_cell(exit_tile_pos + Vector2i(-2, -y), 0, WALL_TILE_INDEX)
				previous_room_floor_tilemap.set_cell(exit_tile_pos + Vector2i(-2, -y), 0, LEFT_FLOOR_TILE_INDEX)
				previous_room_floor_tilemap.set_cell(exit_tile_pos + Vector2i(-1, -y), 0, FLOOR_TILE_INDEX)
				previous_room_floor_tilemap.set_cell(exit_tile_pos + Vector2i(0, -y), 0, FLOOR_TILE_INDEX)
				previous_room_wall_tilemap.set_cell(exit_tile_pos + Vector2i(1, -y), 0, WALL_TILE_INDEX)
				previous_room_floor_tilemap.set_cell(exit_tile_pos + Vector2i(1, -y), 0, RIGHT_FLOOR_TILE_INDEX)
				
			# Move room to the door of the previous room to connect the rooms
			var room_tilemap: TileMapLayer = room.get_node("MapLayer/WallLayer")
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (corridor_height) * TILE_SIZE + (Vector2.UP * TILE_SIZE * 0.5) + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Marker2D2").position).x * TILE_SIZE

			
		add_child(room)
		previous_room = room
