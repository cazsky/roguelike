extends Node2D

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Scenes/spawn_explosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"GOBLIN": preload("res://Characters/goblin.tscn")
}

var num_enemies: int

@onready var tilemap: TileMapLayer = $MapLayer/WallLayer
@onready var entrance: Node2D = $Entrance
@onready var doors: Node2D = $Doors
@onready var enemy_positions: Node2D = $EnemyPositions
@onready var player_detector: Node2D = $PlayerDetector

func _ready() -> void:
	num_enemies = enemy_positions.get_child_count()
	
func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()
	
func _open_doors() -> void:
	for door in doors.get_children():
		door.open()
		
func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		#tilemap.set_cell(tilemap.local_to_map(entry_position.position), 1, Vector2i.ZERO)
		tilemap.set_cell(tilemap.local_to_map(entry_position.position) +Vector2i.DOWN, 0, Vector2i(5,6))
		
func _spawn_enemies() -> void:
	for enemy_position in enemy_positions.get_children():
		var enemy: CharacterBody2D = ENEMY_SCENES.GOBLIN.instantiate()
		var __ = enemy.connect("tree_exited", Callable(self, "_on_enemy_killed"))
		
		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.global_position = enemy_position.global_position
		call_deferred("add_child", spawn_explosion)
		
func _on_player_detector_body_entered(_body: Node2D) -> void:
	print_debug("Room Entered")
	player_detector.queue_free()
	_close_entrance()
	_spawn_enemies()
	
