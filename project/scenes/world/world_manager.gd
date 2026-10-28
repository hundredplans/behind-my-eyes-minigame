extends Node
## Autoload "WorldManager".
## Owns everything that has to survive a location change: moving between
## location scenes, placing the player on a SpawnPoint, the fade, the player
## input lock and simple world flags (e.g. how many times an NPC was talked to).

signal location_changed(location: Location)

const FADE_TIME: float = 0.25
const MAIN_SCENE: String = "res://scenes/main/main.tscn"
const BLINK_TEXTURE: Texture2D = preload("res://assets/sprites/play/Blink_Animation.png")

var current_location: Location

var _lock_count: int = 0
var _transitioning: bool = false
var _flags: Dictionary = {}
var _fade: ColorRect
var _blink: AnimatedSprite2D
var _combat_requested: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)
	_fade = ColorRect.new()
	_fade.color = Color.BLACK
	_fade.modulate.a = 0.0
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(_fade)
	_blink = AnimatedSprite2D.new()
	_blink.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_blink.position = Vector2(320, 180)
	_blink.sprite_frames = _createBlinkFrames()
	_blink.visible = false
	layer.add_child(_blink)

#region Player lock
## Anything that should stop the player (dialogue, cutscene, transition)
## calls lockPlayer() and later unlockPlayer(). Locks stack.
func lockPlayer() -> void: _lock_count += 1
func unlockPlayer() -> void: _lock_count = maxi(_lock_count - 1, 0)
func isPlayerLocked() -> bool: return _lock_count > 0 or _transitioning
func isTransitioning() -> bool: return _transitioning
#endregion

#region Flags
func setFlag(key: String, value: Variant) -> void: _flags[key] = value
func getFlag(key: String, default: Variant = null) -> Variant: return _flags.get(key, default)
#endregion

#region Locations
func registerLocation(location: Location) -> void:
	current_location = location
	location_changed.emit(location)

func getPlayer() -> Player:
	return get_tree().get_first_node_in_group(Player.GROUP) as Player

## Moves the player to [param spawn_id] in [param scene_path].
## An empty scene_path (or the current scene) teleports inside the current location.
func changeLocation(scene_path: String, spawn_id: StringName = &"default") -> void:
	if _transitioning: return
	_transitioning = true
	var player := getPlayer()
	var facing: Vector2i = player.facing if player != null else Vector2i.DOWN

	await _tweenFade(1.0)

	var current_path: String = get_tree().current_scene.scene_file_path
	if !scene_path.is_empty() and scene_path != current_path:
		get_tree().change_scene_to_file(scene_path)
		await get_tree().scene_changed

	_placePlayer(spawn_id, facing)
	await get_tree().physics_frame

	await _tweenFade(0.0)
	_transitioning = false

func _placePlayer(spawn_id: StringName, previous_facing: Vector2i) -> void:
	var player := getPlayer()
	if player == null:
		push_warning("WorldManager: no Player in the new location.")
		return
	for spawn: SpawnPoint in get_tree().get_nodes_in_group(SpawnPoint.GROUP):
		if spawn.id == spawn_id:
			var spawn_facing: Vector2i = spawn.getFacing()
			player.teleport(spawn.global_position,
				previous_facing if spawn_facing == Vector2i.ZERO else spawn_facing)
			return
	push_warning("WorldManager: SpawnPoint '%s' not found, player stays where the scene put it." % spawn_id)
	player.teleport(player.global_position, previous_facing)

func _tweenFade(alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(_fade, "modulate:a", alpha, FADE_TIME)
	await tween.finished
#endregion

#region Combat
## Closes the eyes (same blink as the main menu) and opens the combat screen.
## main.gd asks consumeCombatRequest() on start to know it should go to PLAY.
func startCombat() -> void:
	if _transitioning: return
	_transitioning = true
	_blink.visible = true
	_blink.play(&"CloseEyes")
	await _blink.animation_finished
	_combat_requested = true
	get_tree().change_scene_to_file(MAIN_SCENE)
	await get_tree().scene_changed
	_blink.visible = false # the play screen opens the eyes itself
	current_location = null
	_transitioning = false

func consumeCombatRequest() -> bool:
	var requested := _combat_requested
	_combat_requested = false
	return requested

func _createBlinkFrames() -> SpriteFrames:
	var frames := SpriteFrames.new()
	frames.rename_animation(&"default", &"CloseEyes")
	frames.set_animation_loop(&"CloseEyes", false)
	frames.set_animation_speed(&"CloseEyes", 20.0)
	for i: int in 6:
		var atlas := AtlasTexture.new()
		atlas.atlas = BLINK_TEXTURE
		atlas.region = Rect2(i * 641, 0, 640, 360)
		frames.add_frame(&"CloseEyes", atlas)
	return frames
#endregion
