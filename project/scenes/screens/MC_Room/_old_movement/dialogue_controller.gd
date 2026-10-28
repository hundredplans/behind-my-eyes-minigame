class_name DialogueController
extends Node

var current_dialogue : Dialogue

@onready var dialogue_screen : Panel = $"../HUD/DialogueScreen"
@onready var npc_name_text : Label = $"../HUD/DialogueScreen/Dialogue"
@onready var npc_icon : TextureRect = $"../HUD/DialogueScreen/Dialogue"
@onready var dialogue_text : Label = $"../HUD/DialogueScreen/Dialogue"

@onready var player : Player = $".."

var visable_chars : float
var current_line : int

func ready():
	#close_screen()
	pass

func set_dialogue (dialogue : Dialogue):
	current_dialogue = dialogue
	
	dialogue_screen.visible = true
	npc_name_text.text = dialogue.npc_name
	npc_icon.texture = dialogue.npc_icon
	
	current_line = 0
	_set_line(dialogue.line[0])
	# zablokuj movement gracza

func _procces (delta : float):
	visable_chars += 30*delta
	dialogue_text.visable_characters = int(visable_chars)

func _set_line (line : String):
	visable_chars = 0
	dialogue_text.visable_characters = 0
	dialogue.text = line

func close_screen ():
	dialogue_screen.visable = false
	current_dialogue = null
	# pozwól graczowi się ruszać
