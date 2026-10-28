extends CanvasLayer
## Autoload "DialogueManager".
## var choice: int = await DialogueManager.play(dialogue_data) shows the lines
## one by one and locks the player until the last line is closed.
## E / Enter / Space / left click: finish typing, then go to the next line.
## If the dialogue has choices, they appear after the last line:
## up/down (or the mouse) to pick, E / Enter / click to confirm.

signal started
signal finished(choice: int)

@export var characters_per_second: float = 40.0

@onready var box: Control = %Box
@onready var portrait_rect: TextureRect = %Portrait
@onready var name_label: Label = %Name
@onready var text_label: Label = %Text
@onready var next_arrow: Control = %NextArrow
@onready var choice_box: Control = %Choices
@onready var choice_list: VBoxContainer = %ChoiceList

var _lines: Array[String] = []
var _choices: Array[String] = []
var _line_index: int = 0
var _selected: int = 0
var _active: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	box.visible = false
	choice_box.visible = false

func isActive() -> bool: return _active

## [param speaker] is optional; its npc_name / portrait fill in what the data leaves empty.
## Returns the picked choice index, or -1 when the dialogue has no choices.
func play(data: DialogueData, speaker: NPC = null) -> int:
	if data == null or data.lines.is_empty(): return -1
	var speaker_name: String = data.speaker_name
	var portrait: Texture2D = data.portrait
	if speaker != null:
		if speaker_name.is_empty(): speaker_name = speaker.npc_name
		if portrait == null: portrait = speaker.portrait
	return await say(data.lines, speaker_name, portrait, data.choices)

## Shows plain lines without a DialogueData resource.
func say(lines: Array[String], speaker_name: String = "", portrait: Texture2D = null,
		choices: Array[String] = []) -> int:
	if _active or lines.is_empty(): return -1
	_active = true
	_lines = lines
	_choices = choices
	_line_index = 0
	name_label.text = speaker_name
	name_label.visible = !speaker_name.is_empty()
	portrait_rect.texture = portrait
	portrait_rect.visible = portrait != null
	box.visible = true
	_buildChoices()
	WorldManager.lockPlayer()
	started.emit()
	_showLine()
	return await finished

func _process(delta: float) -> void:
	if !_active: return
	if text_label.visible_ratio < 1.0:
		var total: int = maxi(text_label.get_total_character_count(), 1)
		text_label.visible_ratio = minf(text_label.visible_ratio + characters_per_second * delta / total, 1.0)
	var line_done: bool = text_label.visible_ratio >= 1.0
	var show_choices: bool = line_done and _isLastLine() and !_choices.is_empty()
	if show_choices and !choice_box.visible: _selectChoice(0)
	choice_box.visible = show_choices
	next_arrow.visible = line_done and !show_choices

func _input(event: InputEvent) -> void:
	if !_active: return
	if choice_box.visible:
		if event.is_action_pressed("move_up") or event.is_action_pressed("ui_up"):
			_selectChoice(wrapi(_selected - 1, 0, _choices.size()))
		elif event.is_action_pressed("move_down") or event.is_action_pressed("ui_down"):
			_selectChoice(wrapi(_selected + 1, 0, _choices.size()))
		elif event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
			_close(_selected)
		else: return
		get_viewport().set_input_as_handled()
		return
	if !(event.is_action_pressed("interact") or event.is_action_pressed("ui_accept")
			or event.is_action_pressed("LeftClick")): return
	get_viewport().set_input_as_handled()
	if text_label.visible_ratio < 1.0:
		text_label.visible_ratio = 1.0
		return
	if !_isLastLine():
		_line_index += 1
		_showLine()
	elif _choices.is_empty():
		_close(-1)

func _isLastLine() -> bool: return _line_index >= _lines.size() - 1

func _showLine() -> void:
	text_label.text = _lines[_line_index]
	text_label.visible_ratio = 0.0

func _buildChoices() -> void:
	for child: Node in choice_list.get_children():
		choice_list.remove_child(child)
		child.queue_free()
	for i: int in _choices.size():
		var button := Button.new()
		button.text = _choices[i]
		button.focus_mode = Control.FOCUS_NONE
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.mouse_entered.connect(_selectChoice.bind(i))
		button.pressed.connect(_close.bind(i))
		choice_list.add_child(button)

func _selectChoice(index: int) -> void:
	_selected = index
	for i: int in choice_list.get_child_count():
		var button: Button = choice_list.get_child(i)
		button.text = ("> " if i == index else "  ") + _choices[i]

func _close(choice: int) -> void:
	box.visible = false
	choice_box.visible = false
	_active = false
	WorldManager.unlockPlayer()
	finished.emit(choice)
