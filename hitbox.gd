extends Area2D
class_name Hitbox

@export var damage: int = 1
@export var knockback_force: int = 300

var knockback_direction: Vector2 = Vector2.ZERO

@onready var collision_shape: CollisionShape2D = get_child(0)
@onready var timer: Timer = Timer.new()

var body_inside: bool = false

func _init() -> void:
	var __ = connect("body_entered", Callable(self,"_on_body_entered"))

	
func _ready() -> void:
	assert(collision_shape != null)

	
func _on_body_entered(body: Node2D) -> void:
	_collide(body)
	

func _collide(body: CharacterBody2D) -> void:
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		body.take_damage(damage,knockback_direction,knockback_force)
	
	
