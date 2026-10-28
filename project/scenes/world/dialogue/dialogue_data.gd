class_name DialogueData extends Resource
## One conversation shown in the dialogue box, line by line.
## Create it right in the Inspector of an NPC ("New DialogueData") or save it
## as a .tres in resources/dialogue/ to reuse it.

## Leave empty to use the NPC's name / portrait.
@export var speaker_name: String = ""
@export var portrait: Texture2D
@export_multiline var lines: Array[String] = []
## Buttons shown after the last line, e.g. ["Fight", "Leave"].
## DialogueManager.play() returns the index of the picked one (-1 if none).
@export var choices: Array[String] = []
