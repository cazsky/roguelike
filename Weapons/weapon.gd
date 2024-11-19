extends Node2D
class_name Weapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var charge_particles: GPUParticles2D = $Sword/ChargeParticles
@onready var hitbox: Hitbox = $Sword/Node2D/SwordSprite/Hitbox


func get_input() -> void:
		#Sword Animation
	if Input.is_action_just_pressed("ui_attack") and not animation_player.is_playing():
		animation_player.play("charge")
	elif Input.is_action_just_released("ui_attack"):
		if animation_player.is_playing() and animation_player.current_animation == "charge":
			animation_player.play("attack")
		elif charge_particles.emitting:
			animation_player.play("circular_attack")
			
func move(mouse_direction: Vector2) -> void:
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		# Sword Rotation
		rotation = mouse_direction.angle()
		hitbox.knockback_direction = mouse_direction
		if scale.y == 1 and mouse_direction.x < 0:
			scale.y = -1
		elif scale.y == -1 and mouse_direction.x > 0:
			scale.y = 1
			
func cancel_attack() -> void:
	animation_player.play("cancel_attack")
	
func is_busy() -> bool:
	if animation_player.is_playing() or charge_particles.emitting:
		return true
	return false
