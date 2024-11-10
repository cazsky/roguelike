extends Hitbox

var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0

func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir
	knife_speed = speed
	
	rotation = dir.angle() + PI/4
	
	
func _physics_process(delta: float) -> void:
	position += direction * knife_speed * delta
