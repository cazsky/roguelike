@icon("res://Art/0x72_DungeonTilesetII_v1.7/frames/weapons/weapon_bow.png")
extends Weapon


const ARROW_SCENE: PackedScene = preload("res://Characters/arrow.tscn")

func shoot(offset: int) -> void:
	var arrow: Area2D = ARROW_SCENE.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.launch(global_position, Vector2.UP.rotated(deg_to_rad(rotation_degrees + offset)), 400)
	
func triple_shoot() -> void:
	shoot(0)
	shoot(12)
	shoot(-12)
