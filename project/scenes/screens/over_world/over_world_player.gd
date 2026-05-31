extends CharacterBody2D

signal door_interacted(door_data: Dictionary)

@export var tile_size: int = 16
@export var move_speed: float = 120.0

@onready var interaction_area: Area2D = $InteractionArea

var is_moving: bool = false
var target_position: Vector2
var nearby_door: Door = null


func _ready() -> void:
	target_position = global_position

	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)

	queue_redraw()


func _process(_delta: float) -> void:
	if nearby_door == null:
		nearby_door = get_overlapping_door()

	if nearby_door != null and Input.is_action_just_pressed("Interact_F"):
		door_interacted.emit(nearby_door.interact())
		
func get_overlapping_door() -> Door:
	for area in interaction_area.get_overlapping_areas():
		if area is Door:
			print("Press F")
			return area

	return null

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


func _on_interaction_area_entered(area: Area2D) -> void:
	if area is Door:
		nearby_door = area
		print("Press F")


func _on_interaction_area_exited(area: Area2D) -> void:
	if area == nearby_door:
		nearby_door = null


func set_saved_position(new_position: Vector2) -> void:
	global_position = new_position
	target_position = new_position
	is_moving = false


func _draw() -> void:
	draw_rect(Rect2(Vector2(-8, -8), Vector2(16, 16)), Color.WHITE)
