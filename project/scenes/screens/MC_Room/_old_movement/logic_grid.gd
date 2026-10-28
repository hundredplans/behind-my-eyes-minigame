extends Node

@export var cell_size := 32
var blocked := {}

func world_to_cell(pos: Vector2) -> Vector2i:
	return Vector2i(floori(pos.x / cell_size), floori(pos.y / cell_size))

func cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(cell.x * cell_size + cell_size / 2.0, cell.y * cell_size + cell_size / 2.0)

func is_blocked(cell: Vector2i) -> bool:
	return blocked.get(cell, false)

func set_blocked(cell: Vector2i, value: bool = true) -> void:
	if value:
		blocked[cell] = true
	else:
		blocked.erase(cell)
