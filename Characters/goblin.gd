extends Enemy

@onready var hitbox: Area2D = get_node("Hitbox")

func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()
	
func _ready() -> void:
	print_debug("Goblin Collision ", get_collision_layer_value(1))
