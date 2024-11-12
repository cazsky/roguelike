extends CharacterBody2D
class_name Character

const SPEED = 30.0
const JUMP_VELOCITY = -400.0
const FRICTION = 0.15
const WEIGHT = 10

@export var acceleration:int = 40
@export var max_speed:int = 300
@export var hp: int = 2: set = set_hp
signal hp_changed(new_hp)

@export var flying: bool = false

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var state_machine: Node = get_node("FiniteStateMachine")

var move_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move_and_slide()
	
	
func move() -> void:
	move_direction = move_direction.normalized()
	velocity += move_direction * acceleration
	velocity = velocity.limit_length(max_speed)


func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		self.hp -= dam
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir * force
		else:
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force * 2

func set_hp(new_hp:int) -> void:
	hp = new_hp
	emit_signal("hp_changed", new_hp)
