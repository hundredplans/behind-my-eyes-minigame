class_name CardUI extends Control

const DEFAULT_Z: int = 1
const DRAG_Z: int = 80

signal pressed
signal drag_finished
signal drag_start

@onready var DraggableNode: DraggableControl = %DraggableControl
@onready var CardUIButton: DefaultButton = %CardUIButton
@onready var DescriptionLabel: Label = %DescriptionLabel
@onready var InsidePanel: PanelContainer = %InsidePanel
@onready var NameLabel: Label = %NameLabel
@export var name_lightened: float = 0.2

var card: Card
func setCard(_card: Card) -> void:
	card = _card
	var card_type_color: Color = Data.getColorFromCardType(card.getCardType())
	NameLabel.modulate = card_type_color.lightened(name_lightened)
	NameLabel.text = card.getInfo().getName()
	InsidePanel.self_modulate = card_type_color
	DescriptionLabel.text = card.getInfo().getDescription()
	
func setDisabled(_disabled: bool) -> void: CardUIButton.setDisabled(_disabled)
func getCard() -> Card: return card
func setDraggable(draggable: bool) -> void: DraggableNode.setDraggable(draggable)
