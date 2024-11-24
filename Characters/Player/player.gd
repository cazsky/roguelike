extends Character

enum {UP,DOWN}
const DUST_SCENE: PackedScene = preload("res://Scenes/dust.tscn")

@onready var weapons: Node2D = $Weapons
@onready var current_weapon: Node2D = weapons.get_child(0)
@onready var dust_position: Marker2D = $DustPosition
@onready var parent: Node2D = get_parent()

func _ready() -> void:
	# Setting collision because it gets removed from inspector for wtv reason
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
	current_weapon.on_floor = false
	print_debug(current_weapon, current_weapon.on_floor)


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
	
	if not current_weapon.is_busy():
		if Input.is_action_just_released("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("ui_next_weapon"):
			_switch_weapon(DOWN)
		elif Input.is_action_just_pressed("ui_throw") and weapons.get_child_count() > 1:
			_drop_weapon()
	
	current_weapon.get_input()
		
	
func switch_camera() -> void:
	var main_scene_camera: Camera2D = $"../Camera2D"
	main_scene_camera.position = position
	main_scene_camera.make_current()
	
func cancel_attack() -> void:
	current_weapon.cancel_attack()
	
func _switch_weapon(direction: int) -> void:
	var index: int = current_weapon.get_index()
	if direction == UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0
			
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	
func pick_up_weapon(weapon: Node2D) -> void:
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	weapon.on_floor = false
	current_weapon.hide()
	current_weapon.cancel_attack()
	current_weapon = weapon
	current_weapon.show()
	
func _drop_weapon() -> void:
	var weapon_to_drop: Node2D = current_weapon
	_switch_weapon(UP)
	weapons.call_deferred("remove_child", weapon_to_drop)
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	weapon_to_drop.on_floor = true
	await weapon_to_drop.tree_entered
	weapon_to_drop.show()
	weapon_to_drop.player_detector.show()
	
	var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)
	
	
func spawn_dust() -> void:
	var dust: Sprite2D = DUST_SCENE.instantiate()
	dust.position = dust_position.global_position
	parent.get_child(get_index() - 1).add_sibling(dust)
	
