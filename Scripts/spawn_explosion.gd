extends AnimatedSprite2D


func _ready() -> void:
	self.play()


func _on_animation_finished() -> void:
	queue_free()
