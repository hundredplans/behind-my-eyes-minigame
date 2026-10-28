class_name Door extends InteractionArea
## Moves the player to a SpawnPoint, in another location scene or the same one.
## - ON_TOUCH: triggers when the player walks into it (doorways, stairs, map edges).
## - ON_INTERACT: player has to face it and press E (closed doors, ladders...).
## Resize the CollisionShape2D to cover the door tiles, and put the target
## location's SpawnPoint next to (not on) its own door back.

enum Trigger {ON_TOUCH, ON_INTERACT}

## Leave empty to teleport inside the current location.
@export_file("*.tscn") var target_scene: String = ""
@export var target_spawn: StringName = &"default"
@export var trigger: Trigger = Trigger.ON_TOUCH
@export var locked: bool = false
## Shown when the player tries a locked door.
@export var locked_dialogue: DialogueData
@export var sfx: AudioStream
## Turn off when the location art already shows a door.
@export var show_placeholder: bool = true

func _ready() -> void:
	super()
	$Placeholder.visible = show_placeholder
	if trigger == Trigger.ON_TOUCH:
		collision_layer = 0 # no "[E]" prompt for walk-in doors
		collision_mask = 2 # player body
		monitoring = true
		body_entered.connect(_onBodyEntered)
	elif prompt == "Check":
		prompt = "Open"

func interact(player: Player) -> void:
	super(player)
	enter()

func enter() -> void:
	if WorldManager.isTransitioning(): return
	if locked:
		if locked_dialogue != null: DialogueManager.play(locked_dialogue)
		return
	if sfx != null: Audio.onPlaySFX(sfx)
	WorldManager.changeLocation(target_scene, target_spawn)

func _onBodyEntered(body: Node2D) -> void:
	if body is Player: enter()
