@icon("res://Art/0x72_DungeonTilesetII_v1.7/frames/monsters/slug/slug_anim_f0.png")

extends FiniteStateMachine

var can_jump: bool = false

@onready var jump_timer: Timer = parent.get_node("JumpTimer")
@onready var hitbox: Area2D = parent.get_node("Hitbox")

func _init() -> void:
	_add_state("idle")
	_add_state("jump")
	_add_state("hurt")
	_add_state("dead")
	
	
func _ready() -> void:
	set_state(states.idle)


func _state_logic(_detla: float) -> void:
	if state == states.jump or state == states.idle:
		parent.chase()
		parent.move()


func _get_transition() -> int:
	match state:
		states.idle:
			if can_jump:
				return states.jump
		states.jump:
			if not animation_player.is_playing():
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	parent.acceleration = 10
	parent.max_speed = 50
	match new_state:
		states.idle:
			animation_player.play("move")
		states.jump:
			if is_instance_valid(parent.player):
				parent.path = [parent.global_position, parent.player.position]
			animation_player.play("jump")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
			
func _exit_state(state_exited: int) -> void:
	if state_exited == states.jump:
		can_jump = false
		jump_timer.start()


func _on_jump_timer_timeout() -> void:
	can_jump = true
