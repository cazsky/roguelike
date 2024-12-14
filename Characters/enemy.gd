extends Character
class_name Enemy

var path: PackedVector2Array


@onready var navigation := $NavigationAgent2D as NavigationAgent2D
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var path_timer := $PathTimer as Timer



func _ready() -> void:
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))

	

func chase() -> void:
	if not navigation.is_target_reached():
		var vector_to_next_point: Vector2 = navigation.get_next_path_position() - global_position
		# var distance_to_next_point: float = vector_to_next_point.length()
		move_direction = vector_to_next_point

		
		# Flip sprites
		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true



func _on_path_timer_timeout() -> void:
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		path_timer.stop()
		move_direction = Vector2.ZERO
		
	
func _get_path_to_player() -> void:
	navigation.target_position = player.position
