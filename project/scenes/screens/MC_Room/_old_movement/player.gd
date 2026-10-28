extends Node2D

@export var logic_map_path: NodePath
@export var cell_size := 32
@export var step_time := 0.12

@onready var logic_map: TileMapLayer = get_node(logic_map_path) as TileMapLayer

var current_cell := Vector2i.ZERO
var moving := false

func _ready() -> void:
	if logic_map == null:
		push_error("Player: logic_map_path is not set or points to the wrong node.")
		set_process(false)
		return

	current_cell = Vector2i(
		floori(global_position.x / cell_size),
		floori(global_position.y / cell_size)
	)
	global_position = cell_to_world(current_cell)

func _process(_delta: float) -> void:
	if moving:
		return

	var dir := Vector2i.ZERO

	if Input.is_action_just_pressed("move_up"):
		dir = Vector2i.UP
	elif Input.is_action_just_pressed("move_down"):
		dir = Vector2i.DOWN
	elif Input.is_action_just_pressed("move_left"):
		dir = Vector2i.LEFT
	elif Input.is_action_just_pressed("move_right"):
		dir = Vector2i.RIGHT

	if dir == Vector2i.ZERO:
		return

	var next_cell := current_cell + dir

	if is_blocked(next_cell):
		return

	current_cell = next_cell
	moving = true

	var tween := create_tween()
	tween.tween_property(self, "global_position", cell_to_world(next_cell), step_time)
	tween.finished.connect(func():
		moving = false
	)

func is_blocked(cell: Vector2i) -> bool:
	return logic_map.get_cell_source_id(cell) != -1

func cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(
		cell.x * cell_size + cell_size / 2.0,
		cell.y * cell_size + cell_size / 2.0
	)
