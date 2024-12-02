extends Room

const WEAPONS: Array = [preload("res://Weapons/axe.tscn"),preload("res://Weapons/sword.tscn"), preload("res://Weapons/war_axe.tscn")]


@onready var weapon_pos: Marker2D = $WeaponPos

func _ready() -> void:
	var weapon: Node2D = WEAPONS.pick_random().instantiate()
	weapon.position = weapon_pos.position
	weapon.on_floor = true
	add_child(weapon)
