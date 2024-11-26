@icon("res://Art/0x72_DungeonTilesetII_v1.7/frames/monsters/goblin/goblin_idle_anim_f0.png") 

extends Enemy

@onready var hitbox: Area2D = get_node("Hitbox")

func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()
	
func _ready() -> void:
	pass
