extends CharacterBody2D

@export var tile_size: int = 32
@export var move_speed: float = 120.0

var is_moving: bool = false
var target_position: Vector2

func _ready() -> void:
	target_position = global_position
	queue_redraw()


func _physics_process(delta: float) -> void:
	if is_moving:
		global_position = global_position.move_toward(target_position, move_speed * delta)

		if global_position.is_equal_approx(target_position):
			global_position = target_position
			is_moving = false

		return

	var direction := get_input_direction()

	if direction != Vector2.ZERO:
		target_position = global_position + direction * tile_size
		is_moving = true


func get_input_direction() -> Vector2:
	if Input.is_action_pressed("ui_up"):
		return Vector2.UP

	if Input.is_action_pressed("ui_down"):
		return Vector2.DOWN

	if Input.is_action_pressed("ui_left"):
		return Vector2.LEFT

	if Input.is_action_pressed("ui_right"):
		return Vector2.RIGHT

	return Vector2.ZERO


func _draw() -> void:
	draw_rect(Rect2(Vector2(-16, -16), Vector2(32, 32)), Color.WHITE)
	
func set_saved_position(new_position: Vector2) -> void:
	global_position = new_position
	target_position = new_position
	is_moving = false
