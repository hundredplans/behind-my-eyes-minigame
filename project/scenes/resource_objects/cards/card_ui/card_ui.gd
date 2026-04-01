class_name CardUI extends Node2D

const DEFAULT_Z: int = 1
const DRAG_Z: int = 80

@onready var DefaultTooltipNode: DefaultTooltip = %DefaultTooltipNode
@onready var CardSprite: Sprite2D = %CardSprite
@onready var atlas = %CardSprite.texture as AtlasTexture
@onready var CardUIButton: DefaultControl = %CardUIButton
@onready var DescriptionLabel: Label = %DescriptionLabel
@onready var NameLabel: Label = %NameLabel
@export var name_lightened: float = 0.2

var card: Card
func setCard(_card: Card) -> void:
	card = _card
	var region_x: int = Data.getXFromCardType(card.getCardType())
	var region_y: int = Data.getYFromCardRarity(card.getInfo().getRarity())
	atlas.region = Rect2(region_x,region_y,48,80)
	NameLabel.text = card.getInfo().getName()
	if(NameLabel.text.length()>6):
		NameLabel.add_theme_font_size_override("font_size", 24)
	if(NameLabel.text.length()>8):
		NameLabel.add_theme_font_size_override("font_size", 16)
	var shadow_color: Color = Data.getColorFromCardType(card.getCardType())
	NameLabel.add_theme_color_override("font_shadow_color",shadow_color) 
	#DescriptionLabel.add_theme_color_override("font_shadow_color",shadow_color)
	DescriptionLabel.text = card.getInfo().getDescription()
	setTooltipSelf(false)
	
func setTooltipSelf(tooltip_self: bool) -> void:
	if tooltip_self:
		var tooltip_data := TooltipData.new()
		tooltip_data.setId(card.getInfo().getId())
		tooltip_data.setType(TooltipData.Type.CARD)
		DefaultTooltipNode.onUpdateTooltipDatas([tooltip_data])
		return
	DefaultTooltipNode.onUpdateTooltipDatas(card.getInfo().getTooltipDatas())
	
func onCreateHandCard() -> void: card.remove_hand_card.connect(onRemoveHandCard)
func onRemoveHandCard() -> void: queue_free()
	
func setDisabled(_disabled: bool) -> void: CardUIButton.setDisabled(_disabled)
func getCard() -> Card: return card

func setZIndex(_z_index: int) -> void:
	z_index = _z_index
