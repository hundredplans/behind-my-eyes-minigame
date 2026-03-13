class_name CardUI extends Control

const DEFAULT_Z: int = 1
const DRAG_Z: int = 80
signal drag_start

@onready var DescriptionLabel: Label = %DescriptionLabel
@onready var InsidePanel: PanelContainer = %InsidePanel
@onready var NameLabel: Label = %NameLabel
@export var name_lightened: float = 0.2
func setInfo(card: Card) -> void:
	var card_type_color: Color = Data.getColorFromCardType(card.getCardType())
	NameLabel.modulate = card_type_color.lightened(name_lightened)
	NameLabel.text = card.getInfo().getName()
	InsidePanel.self_modulate = card_type_color
	DescriptionLabel.text = card.getInfo().getDescription()
