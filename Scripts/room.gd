extends Node2D
class_name Room

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Scenes/spawn_explosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"GOBLIN": preload("res://Characters/goblin.tscn"),
	"SKELETON": preload("res://Characters/skeleton.tscn")
}

var num_enemies: int

@onready var tilemap: TileMapLayer = $MapLayer/BottomWall
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
		tilemap.set_cell(tilemap.local_to_map(entry_position.position) + Vector2i.DOWN, 0, Vector2i(2,6))
		tilemap.set_cell(tilemap.local_to_map(entry_position.position) + Vector2i.DOWN * 2, 0, Vector2i(2,7))
		
func _spawn_enemies() -> void:
	for enemy_position in enemy_positions.get_children():
		var enemy: CharacterBody2D
		if randi() % 2 == 0:
			enemy = ENEMY_SCENES.GOBLIN.instantiate()
		else:
			enemy = ENEMY_SCENES.SKELETON.instantiate()
		var __ = enemy.connect("tree_exited", Callable(self, "_on_enemy_killed"))
		
		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)
		
func _on_player_detector_body_entered(_body: Node2D) -> void:
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spawn_enemies()
	else:
		_open_doors()
