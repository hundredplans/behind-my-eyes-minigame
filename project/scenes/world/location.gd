class_name Location extends Node2D
## Put this on the root node of every location scene (MC_Room, hallway, park...).
## It registers itself with WorldManager and sets up the player's camera.

@export var location_name: String = ""
## TileMapLayer whose used area defines the room. The camera never shows
## outside it, and a room smaller than the screen is centered.
@export var bounds: TileMapLayer
## Used instead of [member bounds] for areas without a tilemap (e.g. outside).
@export var bounds_rect: Rect2

func _ready() -> void:
	WorldManager.registerLocation(self)
	setupCamera()

func getBounds() -> Rect2:
	if bounds == null: return bounds_rect
	var cells: Rect2i = bounds.get_used_rect()
	var tile_size := Vector2(bounds.tile_set.tile_size)
	var top_left: Vector2 = bounds.to_global(Vector2(cells.position) * tile_size)
	return Rect2(top_left, Vector2(cells.size) * tile_size)

func setupCamera() -> void:
	var player := WorldManager.getPlayer()
	var rect := getBounds()
	if player == null or !rect.has_area(): return
	var camera: Camera2D = player.camera
	var view: Vector2 = get_viewport_rect().size
	# Grow the limits to at least one screen so small rooms stay centered.
	var limits := rect.grow_individual(
		maxf((view.x - rect.size.x) / 2.0, 0.0), maxf((view.y - rect.size.y) / 2.0, 0.0),
		maxf((view.x - rect.size.x) / 2.0, 0.0), maxf((view.y - rect.size.y) / 2.0, 0.0))
	camera.limit_left = floori(limits.position.x)
	camera.limit_top = floori(limits.position.y)
	camera.limit_right = ceili(limits.end.x)
	camera.limit_bottom = ceili(limits.end.y)
	camera.reset_smoothing()
