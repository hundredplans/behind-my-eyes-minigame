extends Node2D

@onready var DescriptionLabel: Label = %DescriptionLabel
@onready var NameLabel: Label = %NameLabel
@onready var IconTxRect: TextureRect = %IconTxRect
@onready var MainPanel: PanelContainer = %MainPanel
@onready var TopPanel: PanelContainer = %TopPanel

const TOP_PANEL_DARKEN: float = 0.25
var base_color: Color
func setEntityObject(entity_object: EntityObject) -> void:
	NameLabel.text = entity_object.getName()
	IconTxRect.texture = entity_object.getInfo().getTooltipIcon()
	DescriptionLabel.text = entity_object.getInfo().getDescription()

	if entity_object is StatusEffect:
		var card_type: Data.CardType = entity_object.getInfo().getCardType()
		if card_type != Data.CardType.NULL:
			base_color = Data.getColorFromCardType(card_type)
			
	MainPanel.self_modulate = base_color
	NameLabel.modulate = base_color.darkened(TOP_PANEL_DARKEN)
	TopPanel.self_modulate = base_color.darkened(TOP_PANEL_DARKEN)
