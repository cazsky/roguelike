extends Character

#var current_weapon: Node2D

@onready var weapons: Node2D = $Weapons
@onready var current_weapon: Node2D = weapons.get_child(0)

func ready() -> void:
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	# Character Facing Mouse
	if  mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	# Weapon rotation
	current_weapon.move(mouse_direction)
		
		

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
	
	current_weapon.get_input()
		
	
func switch_camera() -> void:
	var main_scene_camera: Camera2D = $"../Camera2D"
	main_scene_camera.position = position
	main_scene_camera.make_current()
	
func cancel_attack() -> void:
	current_weapon.cancel_attack()
	


	
