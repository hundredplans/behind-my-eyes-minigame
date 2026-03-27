class_name CardUI extends Node2D

const DEFAULT_Z: int = 1
const DRAG_Z: int = 80

signal pressed
signal drag_finished
signal drag_start

@onready var IconSprite: Sprite2D = %IconSprite
@onready var CardSprite: Sprite2D = %CardSprite
@onready var DraggableNode: DraggableControl = %DraggableControl
@onready var CardUIButton: DefaultButton = %CardUIButton
@onready var DescriptionLabel: Label = %DescriptionLabel
@onready var NameLabel: Label = %NameLabel
@export var name_lightened: float = 0.2

var card: Card
func setCard(_card: Card) -> void:
	card = _card
	var card_type_color: Color = Data.getColorFromCardType(card.getCardType())
	CardSprite.set_instance_shader_parameter("custom_color", card_type_color)
	IconSprite.texture = Data.getCardTypeIcon(card.getCardType())
	IconSprite.modulate = card_type_color
	NameLabel.text = card.getInfo().getName()
	NameLabel.modulate = card_type_color.lightened(name_lightened)
	DescriptionLabel.text = card.getInfo().getDescription()
	
func setDisabled(_disabled: bool) -> void: CardUIButton.setDisabled(_disabled)
func getCard() -> Card: return card
func setDraggable(draggable: bool) -> void: DraggableNode.setDraggable(draggable)
