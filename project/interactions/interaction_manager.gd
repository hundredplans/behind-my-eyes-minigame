extends Node2D
## Autoload "InteractionManager".
## Shows the "[E] Talk" style prompt above whatever the player is facing.
## The interaction itself is triggered by the Player (see Player._unhandled_input).

@onready var label: Label = $Label

func _ready() -> void:
	z_index = 20
	label.visible = false

func _process(_delta: float) -> void:
	var player := WorldManager.getPlayer()
	var area: InteractionArea = null
	if player != null and !WorldManager.isPlayerLocked() and !player.isMoving():
		area = player.getFocusedInteractable()

	label.visible = area != null
	if area == null: return
	label.text = "[E] %s" % area.prompt
	label.reset_size()
	# Above whichever is higher on screen, so it never covers the player.
	var top: float = minf(area.global_position.y, player.global_position.y)
	global_position = Vector2(area.global_position.x - label.size.x / 2.0, top - label.size.y - 34.0)
