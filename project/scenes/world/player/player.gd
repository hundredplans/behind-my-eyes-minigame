class_name Player extends CharacterBody2D
## Overworld player: Omori-style grid walking.
## - Moves one TILE at a time while a direction is held (WASD / arrows).
## - Tapping a new direction while standing only turns around.
## - The node's position is the player's feet, always on the 16px grid.
## - Walls/NPCs block because they are on physics layer "world".
## - "interact" (E) uses whatever InteractionArea is in front of the player.

signal step_finished

const GROUP: StringName = &"player"
const TILE: int = 16
const DIRECTIONS: Dictionary = {
	&"move_up": Vector2i.UP,
	&"move_down": Vector2i.DOWN,
	&"move_left": Vector2i.LEFT,
	&"move_right": Vector2i.RIGHT,
}

@export var walk_speed: float = 72.0 # pixels per second
## How long a direction must be held before a standing player starts walking.
@export var turn_delay: float = 0.12

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var probe: Area2D = %InteractionProbe
@onready var camera: Camera2D = %Camera2D

var facing: Vector2i = Vector2i.DOWN
var _held: Array[Vector2i] = []
var _moving: bool = false
var _target: Vector2
var _turn_timer: float = 0.0
var _interactables: Array[InteractionArea] = []

func _ready() -> void:
	add_to_group(GROUP)
	global_position = snapToGrid(global_position)
	probe.area_entered.connect(_onProbeAreaEntered)
	probe.area_exited.connect(_onProbeAreaExited)
	_face(facing)
	_setIdle()

func _physics_process(delta: float) -> void:
	_updateHeld()
	if _moving: _step(delta)
	else: _tryStartStep(delta, false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and !_moving and !WorldManager.isPlayerLocked():
		var area := getFocusedInteractable()
		if area == null: return
		get_viewport().set_input_as_handled()
		area.interact(self)

#region Movement
static func snapToGrid(pos: Vector2) -> Vector2:
	return (pos / TILE).round() * TILE

## Instantly puts the player somewhere (used by doors / WorldManager).
func teleport(pos: Vector2, new_facing: Vector2i = facing) -> void:
	_moving = false
	global_position = snapToGrid(pos)
	_face(new_facing)
	_setIdle()
	camera.reset_smoothing()

func isMoving() -> bool: return _moving

func _updateHeld() -> void:
	for action: StringName in DIRECTIONS:
		var dir: Vector2i = DIRECTIONS[action]
		if Input.is_action_pressed(action):
			if !_held.has(dir): _held.append(dir) # newest press wins
		else:
			_held.erase(dir)

func _tryStartStep(delta: float, chaining: bool) -> void:
	if WorldManager.isPlayerLocked() or _held.is_empty():
		_setIdle()
		return
	var dir: Vector2i = _held.back()
	if dir != facing:
		_face(dir)
		if !chaining:
			_turn_timer = turn_delay
			_setIdle()
			return
	if _turn_timer > 0.0:
		_turn_timer -= delta
		return
	var motion := Vector2(dir * TILE)
	if test_move(global_transform, motion):
		_setIdle() # bumped into something
		return
	_target = global_position + motion
	_moving = true
	sprite.play(_animationName(facing))

func _step(delta: float) -> void:
	var to_target: Vector2 = _target - global_position
	var distance: float = walk_speed * delta
	if to_target.length() > distance:
		global_position += to_target.normalized() * distance
		return
	global_position = _target
	_moving = false
	step_finished.emit()
	_tryStartStep(delta, true) # keep walking without a pause while held
#endregion

#region Facing / animation
func _face(dir: Vector2i) -> void:
	facing = dir
	# The probe sits on the tile in front of the feet.
	probe.position = Vector2(dir.x * TILE * 1.5, -TILE / 2.0 + dir.y * TILE)
	if sprite.animation != _animationName(dir):
		var was_playing := sprite.is_playing()
		sprite.animation = _animationName(dir)
		if was_playing: sprite.play()

func _setIdle() -> void:
	sprite.animation = _animationName(facing)
	sprite.stop()
	sprite.frame = 0

func _animationName(dir: Vector2i) -> StringName:
	match dir:
		Vector2i.UP: return &"Move_up"
		Vector2i.LEFT: return &"Move_left"
		Vector2i.RIGHT: return &"Move_right"
	return &"Move_down"
#endregion

#region Interaction
## The InteractionArea the player is currently facing (or null).
func getFocusedInteractable() -> InteractionArea:
	for area: InteractionArea in _interactables:
		if is_instance_valid(area) and area.isEnabled(): return area
	return null

func _onProbeAreaEntered(area: Area2D) -> void:
	if area is InteractionArea and !_interactables.has(area): _interactables.append(area)

func _onProbeAreaExited(area: Area2D) -> void:
	if area is InteractionArea: _interactables.erase(area)
#endregion
