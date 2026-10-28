class_name NPC extends CharacterBody2D
## A character the player can talk to.
## - Blocks the player (physics layer "world") with its whole 32x32 body;
##   position = feet on the 16px grid.
## - Talking plays [member dialogue] the first time and [member repeat_dialogue]
##   afterwards (if set). The talk count is remembered across location changes.
## - A dialogue choice named [member combat_choice] ("Fight") starts combat.
## - Connect [signal talked_to] for anything special (give item, start a
##   conversation battle, open a door...).

signal talked_to(times: int)

@export var npc_name: String = "NPC"
@export var portrait: Texture2D
## Replaces the Sprite2D texture (a single 32x32 frame, feet at the bottom).
@export var texture: Texture2D:
	set(value):
		texture = value
		if is_node_ready(): sprite.texture = value
@export var dialogue: DialogueData
@export var repeat_dialogue: DialogueData
## Picking a dialogue choice with this text starts a conversation battle
## (blink -> combat screen). Leave empty if this NPC never fights.
@export var combat_choice: String = "Fight"

@onready var sprite: Sprite2D = %Sprite2D
@onready var interaction_area: InteractionArea = %InteractionArea

func _ready() -> void:
	if texture != null: sprite.texture = texture
	interaction_area.interacted.connect(_onInteracted)

## Key used for WorldManager flags; unique per NPC per location.
func getFlagKey() -> String:
	var scene_path: String = owner.scene_file_path if owner != null else ""
	return "%s:%s:talked" % [scene_path, name]

func getTimesTalked() -> int:
	return WorldManager.getFlag(getFlagKey(), 0)

func _onInteracted(_player: Player) -> void:
	var times: int = getTimesTalked()
	var data: DialogueData = repeat_dialogue if times > 0 and repeat_dialogue != null else dialogue
	WorldManager.setFlag(getFlagKey(), times + 1)
	var choice: int = -1
	if data != null: choice = await DialogueManager.play(data, self)
	if choice >= 0 and !combat_choice.is_empty() and data.choices[choice] == combat_choice:
		WorldManager.startCombat()
	talked_to.emit(times + 1)
