extends Enemy

func duplicate_slug() -> void:
	if scale > Vector2(1,1):
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
		_spawn_slug(impulse_direction)
		_spawn_slug(impulse_direction * -1)




func _spawn_slug(direction: Vector2) -> void:
	var slime: CharacterBody2D = load("res://Characters/slug_boss.tscn").instantiate()
	slime.position = position
	slime.scale = scale/2
	slime.hp = max_hp/2.0
	slime.max_hp = max_hp/2.0
	get_parent().add_child(slime)
	slime.velocity += direction * 150
