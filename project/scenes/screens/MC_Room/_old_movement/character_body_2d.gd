extends CharacterBody2D

@export var cell_size := 32
@export var step_time := 0.12

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_up: RayCast2D = $up
@onready var ray_down: RayCast2D = $down
@onready var ray_left: RayCast2D = $left
@onready var ray_right: RayCast2D = $right

var moving := false


func _ready() -> void:
	_snap_to_grid()

	# Make sure the walk animations do not loop
	for name in ["Move_up", "Move_down", "Move_left", "Move_right"]:
		anim.sprite_frames.set_animation_loop(name, false)

	_update_rays()


func _physics_process(_delta: float) -> void:
	if moving:
		return

	var dir := Vector2i.ZERO

	if Input.is_action_just_pressed("ui_up"):
		dir = Vector2i.UP
	elif Input.is_action_just_pressed("ui_down"):
		dir = Vector2i.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		dir = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		dir = Vector2i.RIGHT
	else:
		return

	if not _can_move(dir):
		return

	_play_move_animation(dir)
	_move(dir)


func _can_move(dir: Vector2i) -> bool:
	match dir:
		Vector2i.UP:
			return not ray_up.is_colliding()
		Vector2i.DOWN:
			return not ray_down.is_colliding()
		Vector2i.LEFT:
			return not ray_left.is_colliding()
		Vector2i.RIGHT:
			return not ray_right.is_colliding()

	return false


func _move(dir: Vector2i) -> void:
	moving = true

	var target_pos := global_position + Vector2(dir) * cell_size
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_pos, step_time)
	tween.finished.connect(func():
		moving = false
		_update_rays()
	)


func _play_move_animation(dir: Vector2i) -> void:
	var anim_name := ""

	match dir:
		Vector2i.UP:
			anim_name = "Move_up"
		Vector2i.DOWN:
			anim_name = "Move_down"
		Vector2i.LEFT:
			anim_name = "Move_left"
		Vector2i.RIGHT:
			anim_name = "Move_right"

	if anim_name != "":
		anim.play(anim_name)


func _snap_to_grid() -> void:
	global_position = Vector2(
		floori(global_position.x / cell_size) * cell_size + cell_size / 2.0,
		floori(global_position.y / cell_size) * cell_size + cell_size / 2.0
	)


func _update_rays() -> void:
	ray_up.force_raycast_update()
	ray_down.force_raycast_update()
	ray_left.force_raycast_update()
	ray_right.force_raycast_update()
