@icon("res://Art/0x72_DungeonTilesetII_v1.7/frames/weapons/weapon_anime_sword.png")

extends Node2D
class_name Weapon

@export var on_floor: bool = true
@export var ranged_weapon: bool = false
@export var rotation_offset: int = 0


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var charge_particles: GPUParticles2D = $Node2D/ChargeParticles
@onready var hitbox: Hitbox = $Node2D/WeaponSprite/Hitbox
@onready var player_detector: Area2D = $PlayerDetector
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var ui: CanvasLayer = $UI
@onready var ability_icon: TextureProgressBar = $UI/AbilityIcon

var tween: Tween = null
var can_active_ability: bool = true
var weapon_id: String = ""

func _ready() -> void:
	if weapon_id == "":
		weapon_id = str(get_instance_id())  # Default to a unique ID if not set
	if not on_floor:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		# Hide to not see collision shape
		player_detector.hide()
	# Hide the ability icon if the weapon doesnt have it
	connect("hidden", _on_hide)
	connect("draw", _on_show)
		
		

func get_input() -> void:
	# Weapon Animation
	# Check if on floor so it doesnt play charge on the floor
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

			
func move(mouse_direction: Vector2) -> void:
	if ranged_weapon:
		rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	else:
		if not animation_player.is_playing() or animation_player.current_animation == "charge":
			# Weapon Rotation
			rotation = mouse_direction.angle()
			hitbox.knockback_direction = mouse_direction
			if scale.y == 1 and mouse_direction.x < 0:
				scale.y = -1
			elif scale.y == -1 and mouse_direction.x > 0:
				scale.y = 1
			
func cancel_attack() -> void:
	animation_player.play("RESET")
	
func is_busy() -> bool:
	if animation_player.is_playing() or charge_particles.emitting:
		return true
	return false


func _on_player_detector_body_entered(body: CharacterBody2D) -> void:
	# CharacterBody2D to make sure its Player body
	if body != null and body is CharacterBody2D:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		# Hide to not see collision shape
		player_detector.hide()
		if animation_player.is_playing():
			animation_player.stop()
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		if tween:
			tween.kill()
		player_detector.set_collision_mask_value(2, true)
		
		
# Function for throwing the weapon 
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

func _on_show() -> void:
	ability_icon.show()

func _on_hide() -> void:
	ability_icon.hide()

func get_texture() -> Texture:
	return get_node("Node2D/WeaponSprite").texture
