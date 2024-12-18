extends TextureRect


@onready var border: ReferenceRect = $ReferenceRect


func initialise(texture: Texture) -> void:
	self.texture = texture
	
func select() -> void:
	border.show()
	
func deselect() -> void:
	border.hide()
