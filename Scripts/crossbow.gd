extends Weapon


const ARROW_SCENE: PackedScene = preload("res://Characters/arrow.tscn")

func shoot(offset: int) -> void:
	var arrow: Area2D = ARROW_SCENE.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.launch(global_position, Vector2.LEFT.rotated(deg_to_rad(rotation_degrees + offset)), 400)
	
	
