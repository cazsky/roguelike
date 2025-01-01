extends CanvasLayer

const MIN_HEALTH: int = 23
const INVENTORY_ITEM_SCENE: PackedScene = preload("res://Scenes/inventory_item.tscn")

var max_hp: int = 4

@onready var player: CharacterBody2D = get_parent().get_node("Player")
@onready var health_bar: TextureProgressBar = get_node("HealthBar")
#@onready var health_bar_tween: Tween = get_tree().create_tween()

@onready var inventory: HBoxContainer = $PanelContainer/Inventory

func _ready() -> void:
	max_hp = player.max_hp
	_update_health_bar(100)
	
func _update_health_bar(new_value: int) -> void:
	var health_bar_tween: Tween = get_tree().create_tween()
	health_bar_tween.tween_property(health_bar, "value", new_value, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)


func _on_player_hp_changed(new_hp: int) -> void:
	var new_health: int = int((100-MIN_HEALTH) * float(new_hp) / max_hp) + MIN_HEALTH
	_update_health_bar(new_health)


func _on_player_weapon_dropped(index: int) -> void:
	inventory.get_child(index).queue_free()

func _on_player_weapon_picked_up(weapon_texture: Texture) -> void:
	var new_inventory_item: TextureRect = INVENTORY_ITEM_SCENE.instantiate()
	inventory.add_child(new_inventory_item)
	new_inventory_item.initialise(weapon_texture)

func _on_player_weapon_switched(prev_index: int, new_index: int) -> void:
	# Validate indices to avoid null instance errors
	if inventory and prev_index >= 0 and prev_index < inventory.get_child_count():
		inventory.get_child(prev_index).deselect()
	else:
		print_debug("Invalid prev_index: ", prev_index)

	if inventory and new_index >= 0 and new_index < inventory.get_child_count():
		inventory.get_child(new_index).select()
	else:
		print_debug("Invalid new_index: ", new_index)
