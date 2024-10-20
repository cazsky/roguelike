extends Character
class_name Enemy

var path: PackedVector2Array

#@onready var navigation: NavigationAgent2D = get_tree().current_scene.get_node("NavigationAgent2D")
@onready var navigation := $NavigationAgent2D as NavigationAgent2D
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")

#func _physics_process(delta: float) -> void:
	#var dir = to_local(navigation.get_next_path_position().normalized()) / 60
	#velocity = lerp(dir * SPEED, Vector2.ZERO, FRICTION)
	#move_and_slide()


func chase() -> void:
	if path:
		var vector_to_next_point: Vector2 = path[-1] - global_position
		var distance_to_next_point: float = vector_to_next_point.length()
		if distance_to_next_point < 1: #Change 1 to a bigger number to have enemy move faster
			path.remove_at(0)
			if not path:
				return
		move_direction = vector_to_next_point
		
		# Flip sprites
		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true
	#navigation.target_position = player.global_position



func _on_path_timer_timeout() -> void:
	navigation.set_target_position(player.global_position)
	path.append(navigation.get_target_position())
	#chase()
