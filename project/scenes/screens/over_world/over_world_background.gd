extends Node2D

@export var tile_size: int = 32
@export var grid_width: int = 40
@export var grid_height: int = 30

func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var map_size := Vector2(grid_width * tile_size, grid_height * tile_size)

	# Tło
	draw_rect(
		Rect2(Vector2.ZERO, map_size),
		Color(0.15, 0.18, 0.15)
	)

	# Linie pionowe
	for x in range(grid_width + 1):
		var from := Vector2(x * tile_size, 0)
		var to := Vector2(x * tile_size, map_size.y)
		draw_line(from, to, Color(0.25, 0.30, 0.25), 1.0)

	# Linie poziome
	for y in range(grid_height + 1):
		var from := Vector2(0, y * tile_size)
		var to := Vector2(map_size.x, y * tile_size)
		draw_line(from, to, Color(0.25, 0.30, 0.25), 1.0)
