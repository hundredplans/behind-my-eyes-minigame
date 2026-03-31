extends Control

@onready var DescriptionLabel: Label = %DescriptionLabel
@onready var NameLabel: Label = %NameLabel
@onready var IconTxRect: TextureRect = %IconTxRect
@onready var MainPanel: PanelContainer = %MainPanel
@onready var TopPanel: PanelContainer = %TopPanel

const TOP_PANEL_DARKEN: float = 0.25
var base_color: Color
func setTooltipData(tooltip_data: TooltipData) -> void:
	var info: ResourceInfo = tooltip_data.getInfo()
	NameLabel.text = info.getName()
	IconTxRect.texture = info.getTooltipIcon()
	DescriptionLabel.text = info.getDescription()

	if tooltip_data.getType() == TooltipData.Type.STATUS_EFFECT\
	or tooltip_data.getType() == TooltipData.Type.CARD:
		var card_type: Data.CardType = info.getCardType()
		if card_type != Data.CardType.NULL:
			base_color = Data.getColorFromCardType(card_type)
			
	MainPanel.self_modulate = base_color
	NameLabel.modulate = base_color.darkened(TOP_PANEL_DARKEN)
	TopPanel.self_modulate = base_color.darkened(TOP_PANEL_DARKEN)
	call_deferred("reset_size")
