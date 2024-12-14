extends Hitbox

var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0
var enemy_exited: bool = false


# Ensure connections are set up when the knife is instantiated
func _ready() -> void:
	if not is_connected("body_exited", Callable(self, "_on_body_exited")):
		connect("body_exited", Callable(self, "_on_body_exited"))
	
		
func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir
	knife_speed = speed
	
	rotation = dir.angle() + PI/4

	
	
func _physics_process(delta: float) -> void:
	position += direction * knife_speed * delta


func _on_body_exited(_body: Node2D) -> void:
	if not enemy_exited:
		enemy_exited = true
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		
func _collide(body: Node2D) -> void:
	if enemy_exited:
		if body != null and body.has_method("take_damage") :
			body.take_damage(damage,knockback_direction,knockback_force)
		queue_free()
		
