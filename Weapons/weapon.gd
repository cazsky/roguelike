@icon("res://Art/0x72_DungeonTilesetII_v1.7/frames/weapons/weapon_anime_sword.png")

extends Node2D
class_name Weapon

@export var on_floor: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var charge_particles: GPUParticles2D = $Node2D/ChargeParticles
@onready var hitbox: Hitbox = $Node2D/WeaponSprite/Hitbox
@onready var player_detector: Area2D = $PlayerDetector
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var ui: CanvasLayer = $UI
@onready var ability_icon: TextureProgressBar = $UI/AbilityIcon

var tween: Tween = null
var can_active_ability: bool = true

func _ready() -> void:
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
		elif Input.is_action_just_pressed("ui_active_ability") and animation_player.has_animation("active_ability") and not is_busy() and can_active_ability:
			can_active_ability = false
			cooldown_timer.start()
			ui.recharge_ability_animation(cooldown_timer.wait_time)
			animation_player.play("active_ability")
	if animation_player.has_animation("active_ability"):
		ability_icon.visible = true
	else:
		ability_icon.visible = false
			
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


func _on_cooldown_timer_timeout() -> void:
	can_active_ability = true

func _show_ability_icon() -> void:
	ability_icon.show()

func _hide_ability_icon() -> void:
	ability_icon.hide()
