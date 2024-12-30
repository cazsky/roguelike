extends TileMapLayer

@onready var walls: TileMapLayer = $"../ObstacleLayer"


var collision_layers: Array = []


func _ready() -> void:
	collision_layers.append_array(walls.get_used_cells_by_id(0))
	collision_layers.append_array(walls.get_used_cells_by_id(1))

	
func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	if coords in collision_layers:
		return true
	return false

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if coords in collision_layers:
		tile_data.set_navigation_polygon(0, null)
