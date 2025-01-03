@icon("res://Art/0x72_DungeonTilesetII_v1.7/frames/monsters/slug/slug_anim_f0.png")
extends Enemy

@onready var hitbox: Area2D = get_node("Hitbox")

func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()
	if is_instance_valid(player):
		if player.global_position.y > global_position.y:
			z_index = 0
		else:
			# Why does setting +1 not work????
			z_index = player.z_index + 2


func duplicate_slug() -> void:
	if scale > Vector2(1,1):
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
		_spawn_slug(impulse_direction)
		_spawn_slug(impulse_direction * -1)


func _spawn_slug(direction: Vector2) -> void:
	var slug: CharacterBody2D = load("res://Characters/slug_boss.tscn").instantiate()
	slug.position = position
	slug.scale = scale/2
	slug.hp = max_hp/2.0
	slug.max_hp = max_hp/2.0
	get_parent().add_child(slug)
	slug.velocity += direction * 150
