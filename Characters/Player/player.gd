extends Character

enum {UP,DOWN}
const DUST_SCENE: PackedScene = preload("res://Scenes/Effects/dust.tscn")

@onready var weapons: Node2D = $Weapons
@onready var current_weapon: Node2D = weapons.get_child(0)
@onready var dust_position: Marker2D = $DustPosition
@onready var parent: Node2D = get_parent()
@onready var animation_player = $AnimationPlayer

signal weapon_switched(prev_index, new_index)
signal weapon_picked_up(weapon_texture)
signal weapon_dropped(index)

func _ready() -> void:
	print_debug("Weapons before restoration: ", weapons.get_child_count())
	for child in weapons.get_children():
		print_debug("Existing weapon ID: ", child.weapon_id)

	_restore_previous_state()

	print_debug("Weapons after restoration: ", weapons.get_child_count())
	for child in weapons.get_children():
		print_debug("Existing weapon ID: ", child.weapon_id)
	emit_signal("weapon_picked_up", weapons.get_child(0).get_texture())
	# Setting collision because it gets removed from inspector for wtv reason
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
	# Game crashes sometimes setting on_floor to false before instance spawns
	call_thread_safe("set_spawn_weapon_not_on_floor")


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
	
	switch_weapon_input()
	
	current_weapon.get_input()

	
func switch_camera() -> void:
	var main_scene_camera: Camera2D = $"../Camera2D"
	main_scene_camera.position = position
	main_scene_camera.make_current()
	
func cancel_attack() -> void:
	current_weapon.cancel_attack()
	
func _switch_weapon(direction: int) -> void:
	# Current_weapon.get_parent() returns spawn_room, prolly cause of call_deferred
	var prev_index: int = current_weapon.get_index()
	var index: int = prev_index
	if direction == UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0
	index = clamp(index, 0, weapons.get_child_count())
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	# Null value when switching weapons fast
	# Index goes to either 5 or 7 when theres only 2 weapons
	current_weapon.show()
	#SavedData.equipped_weapon_index = index
	emit_signal("weapon_switched", prev_index, index)
	
	
func pick_up_weapon(weapon: Node2D) -> void:
	# Cant use DUPLICATE_USE_INSTANTIATION because it wont duplicate the child nodes added during runtime, so use everything but that #yep
	var weapon_copy = weapon.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_GROUPS | DUPLICATE_SIGNALS)
	SavedData.weapons.append(weapon_copy) 
	
	var prev_index: int = SavedData.equipped_weapon_index
	var new_index: int = weapons.get_child_count()
	SavedData.equipped_weapon_index = new_index
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	await get_tree().process_frame
	weapon.on_floor = false
	current_weapon.hide()
	current_weapon.cancel_attack() # This might be causing issues
	current_weapon = weapon
	current_weapon.show()
	
	emit_signal("weapon_picked_up", weapon.get_texture())
	emit_signal("weapon_switched", prev_index, new_index)
	
func _drop_weapon() -> void:
	SavedData.weapons.remove_at(current_weapon.get_index() - 1)
	var weapon_to_drop: Node2D = current_weapon
	_switch_weapon(UP)
	
	emit_signal("weapon_dropped", weapon_to_drop.get_index())
	
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
	
func set_spawn_weapon_not_on_floor():
	current_weapon.on_floor = false
	
func _restore_previous_state() -> void:
	# Track existing weapon IDs
	var existing_weapon_ids = []
	for child in weapons.get_children():
		if child.has_method("weapon_id"):  # Ensure the property exists
			existing_weapon_ids.append(child.weapon_id)

	self.hp = SavedData.hp

	for saved_weapon in SavedData.weapons:
		# Check if a weapon with the same ID already exists
		if saved_weapon.weapon_id in existing_weapon_ids:
			print_debug("Weapon already exists with ID: ", saved_weapon.weapon_id)
			continue  # Skip adding it again

		# Duplicate and add the new weapon
		var new_weapon = saved_weapon.duplicate()
		new_weapon.position = Vector2.ZERO
		weapons.add_child(new_weapon)
		new_weapon.hide()

		emit_signal("weapon_picked_up", new_weapon.get_texture())
		existing_weapon_ids.append(new_weapon.weapon_id)  # Track the new weapon ID

	# Equip the previously selected weapon
	var equipped_index = SavedData.equipped_weapon_index
	if equipped_index >= 0 and equipped_index < weapons.get_child_count():
		var current_weapon = weapons.get_child(equipped_index)
		current_weapon.show()

	emit_signal("weapon_switched", -1, SavedData.equipped_weapon_index)




	
func switch_weapon_input() -> void:
	if not current_weapon.is_busy():
		if Input.is_action_just_released("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("ui_next_weapon"):
			_switch_weapon(DOWN)
		elif Input.is_action_just_pressed("ui_throw") and weapons.get_child_count() > 1:
			_drop_weapon()
			
			
func _emit_weapon_picked_up():
	emit_signal("weapon_picked_up", weapons.get_child(0).get_texture())
