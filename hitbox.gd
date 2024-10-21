extends Area2D
class_name Hitbox

@export var damage: int = 1
@export var knockback_force: int = 300

var knockback_direction: Vector2 = Vector2.ZERO

@onready var collision_shape: CollisionShape2D = get_child(0)


func _init() -> void:
	connect("body_entered", Callable(self,_on_body_entered(collision_shape)))
	
func _ready() -> void:
	assert(collision_shape != null)
	
func _on_body_entered(body: PhysicsBody2D) -> void:
	body.take_damage(damage,knockback_direction,knockback_force)
	
