class_name InteractionArea extends Area2D
## Something the player can use with "interact" (E) while facing it.
## Add interaction_area.tscn as a child of any object, give it a CollisionShape2D
## covering the object's tiles, and connect "interacted" (or extend this script,
## like Door does). It lives on physics layer 3 "interactable", which the
## player's InteractionProbe scans.

signal interacted(player: Player)

const LAYER: int = 4 # physics layer 3 "interactable"

## Text shown in the prompt above the object, e.g. "Talk", "Open", "Check".
@export var prompt: String = "Check"
@export var enabled: bool = true

func _ready() -> void:
	collision_layer = LAYER
	monitorable = true

func isEnabled() -> bool: return enabled

func interact(player: Player) -> void:
	interacted.emit(player)
