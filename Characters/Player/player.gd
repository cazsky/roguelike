extends Character

@onready var sword: Node2D = get_node("Sword")
@onready var sword_animation_player: AnimationPlayer = sword.get_node("SwordAnimationPlayer")
@onready var sword_hitbox: Area2D = get_node("Sword/Node2D/SwordSprite/Hitbox")

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	# Character Facing Mouse
	if  mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	# Sword Rotation
	sword.rotation = mouse_direction.angle()
	sword_hitbox.knockback_direction = mouse_direction
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
		
		

func get_input() -> void:
	# Movement
	move_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_up"):
		move_direction += Vector2.UP
	if Input.is_action_pressed("ui_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		move_direction += Vector2.RIGHT
	
	#Sword Animation
	if Input.is_action_just_pressed("ui_attack") and not sword_animation_player.is_playing():
		sword_animation_player.play("attack")
		
func _ready() -> void:
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
	
func switch_camera() -> void:
	var main_scene_camera: Camera2D = $"../Camera2D"
	main_scene_camera.position = position
	main_scene_camera.make_current()
	
	


	
