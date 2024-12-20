extends TextureRect


@onready var border: ReferenceRect = $ReferenceRect

@warning_ignore("shadowed_variable_base_class")
func initialise(texture: Texture) -> void:
	self.texture = texture
	
func select() -> void:
	border.show()
	
func deselect() -> void:
	border.hide()
