extends Room

@onready var collision_shape: CollisionShape2D = $Stairs/CollisionShape2D

func _ready() -> void:
	super()
	print_debug("Num Enemies:", num_enemies)
	collision_shape.disabled = true

func _on_enemy_killed() -> void:
	super()
	print_debug("Num Enemies:", num_enemies)
	if num_enemies == 0:
		print_debug("#yep")
		collision_shape.disabled = false
