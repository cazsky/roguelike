extends Room

@onready var collision_shape: CollisionShape2D = $Stairs/CollisionShape2D

func _ready() -> void:
	super()
	collision_shape.disabled = true

func _on_enemy_killed() -> void:
	super()
	if num_enemies == 0:
		collision_shape.disabled = false
