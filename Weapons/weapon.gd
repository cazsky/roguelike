extends Node2D
class_name Weapon

@export var on_floor: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var charge_particles: GPUParticles2D = $Node2D/ChargeParticles
@onready var hitbox: Hitbox = $Node2D/WeaponSprite/Hitbox
@onready var player_detector: Area2D = $PlayerDetector

var tween: Tween = null


func _ready() -> void:
	print_debug(self, on_floor)
	if not on_floor:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		# Hide to not see collision shape
		player_detector.hide()


func get_input() -> void:
	# Weapon Animation
	if not on_floor:
		if Input.is_action_just_pressed("ui_attack") and not animation_player.is_playing():
			animation_player.play("charge")
		elif Input.is_action_just_released("ui_attack"):
			if animation_player.is_playing() and animation_player.current_animation == "charge":
				animation_player.play("attack")
			elif charge_particles.emitting:
				animation_player.play("strong_attack")
			
func move(mouse_direction: Vector2) -> void:
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		# Weapon Rotation
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


func _on_player_detector_body_entered(body: Node2D) -> void:
	# CharacterBody2D to make sure its Player body
	if body != null and body is CharacterBody2D:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		# Hide to not see collision shape
		player_detector.hide()
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		if tween:
			tween.kill()
		player_detector.set_collision_mask_value(2, true)
		
		
func interpolate_pos(initial_pos: Vector2, final_pos: Vector2) -> void:
	position = initial_pos
	tween = create_tween()
	tween.tween_property(self,"position",final_pos,0.8).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	player_detector.set_collision_mask_value(1,true)
	tween.connect("finished", _on_Tween_tween_completed)
	
func _on_Tween_tween_completed() -> void:
	player_detector.set_collision_mask_value(2,true)	
