extends Node

@export var visual_map: TileMapLayer

func _ready() -> void:
	if visual_map == null:
		push_error("GridManager: visual_map nie jest przypięty w Inspectorze.")
		set_process(false)

func is_logical_cell_walkable(cell: Vector2i) -> bool:
	if visual_map == null:
		return false

	var origin := cell * 2

	for y in range(2):
		for x in range(2):
			var vcell := origin + Vector2i(x, y)
			var data := visual_map.get_cell_tile_data(vcell)

			if data == null:
				continue

			if data.has_custom_data("walkable") and data.get_custom_data("walkable") == false:
				return false

	return true
