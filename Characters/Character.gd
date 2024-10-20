extends CharacterBody2D
class_name Character

const SPEED = 30.0
const JUMP_VELOCITY = -400.0
const FRICTION = 0.15
const WEIGHT = 10

@export var acceleration:int = 40
@export var max_speed:int = 300

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

var move_direction: Vector2 = Vector2.ZERO




func _physics_process(delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move_and_slide()
	
	
	
func move() -> void:
	move_direction = move_direction.normalized()
	velocity += move_direction * acceleration
	velocity = velocity.limit_length(max_speed)
