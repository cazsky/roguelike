extends Enemy

const MAX_DISTANCE_TO_PLAYER:int = 80
const MIN_DISTANCE_TO_PLAYER:int = 40

const THROWING_KNIFE: PackedScene = preload("res://Characters/throwingKnife.tscn")

@export var projectile_speed: int = 150
var can_attack: bool = true

var distance_to_player: float

@onready var attack_timer: Timer = $AttackTimer
@onready var aim_raycast: RayCast2D = $AimRayCast
#@onready var WallLayer: TileMapLayer = $MapLayer/WallLayer


func _on_path_timer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		else:
			aim_raycast.target_position = (player.position - global_position) * 0.9
			if can_attack and state_machine.state == state_machine.states.idle and not aim_raycast.is_colliding():
				can_attack = false
				_throw_knife()
				attack_timer.start()
	else:
		path_timer.stop()
		move_direction = Vector2.ZERO


func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	navigation.target_position = global_position + dir * 100
	
func _throw_knife() -> void:
	var projectile: Area2D = THROWING_KNIFE.instantiate()
	projectile.launch(global_position, (player.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)


func _on_attack_timer_timeout() -> void:
	can_attack = true
