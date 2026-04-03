class_name CardUI extends Node2D

const DEFAULT_Z: int = 1
const DRAG_Z: int = 80
const TRIGGERED_Z_INDEX: int = 100

@onready var TriggerPointTypeSprite: Sprite2D = %TriggerPointTypeSprite
@onready var DefaultTooltipNode: DefaultTooltip = %DefaultTooltipNode
@onready var CardSprite: Sprite2D = %CardSprite
@onready var atlas = %CardSprite.texture as AtlasTexture
@onready var CardUIButton: DefaultControl = %CardUIButton
@onready var DescriptionLabel: Label = %DescriptionLabel
@onready var NameLabel: Label = %NameLabel

@export var name_lightened: float = 0.2
@export var collab_icon: AtlasTexture
@export var win_icon: AtlasTexture
@export var loss_icon: AtlasTexture
@export var none_icon: AtlasTexture
@export var trigger_point_type_display_delay: float = 0.25

@export var hover_scale_offset := Vector2(0.1, 0.1)
@export var hover_rotation_offset: float = PI / 32.0
@export var hover_animation_time: float = 0.3
@export var card_hovered_sfx: AudioStream

var HoverTween: Tween
var deckBuilder: bool = false
var inDeck: bool = false
var z_indexCopy: int
var card: Card
var deckSlot: int
var hovering: bool

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
	DefaultTooltipNode.onUpdateTooltipDatas(card.getInfo().getTooltipDatas())
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

func _on_control_mouse_entered() -> void:
	if !deckBuilder and !hovering and CardSprite != null:
		Audio.onPlaySFX(card_hovered_sfx)
		hovering = true
		if HoverTween: HoverTween.kill()
		HoverTween = create_tween()
		
		var delay: float = hover_animation_time / 3.0
		HoverTween.parallel().tween_property(CardSprite, "rotation", -hover_rotation_offset, delay)\
			.as_relative().set_trans(Tween.TRANS_SINE)
		HoverTween.parallel().tween_property(CardSprite, "scale", hover_scale_offset, delay * 2)\
			.as_relative().set_trans(Tween.TRANS_SINE)
		HoverTween.tween_property(CardSprite, "rotation", hover_rotation_offset * 2, delay)\
			.as_relative().set_trans(Tween.TRANS_SINE)
		HoverTween.tween_property(CardSprite, "scale", -hover_scale_offset, delay)\
			.as_relative().set_trans(Tween.TRANS_SINE)
		HoverTween.parallel().tween_property(CardSprite, "rotation", -hover_rotation_offset , delay)\
			.as_relative().set_trans(Tween.TRANS_SINE)
		await HoverTween.finished
		hovering = false


func onCardTriggeredTravel() -> void:
	setDisabled(true)
	setZIndex(TRIGGERED_Z_INDEX)

func onCardTriggeredDisplay(point_type: Data.PointType) -> void:
	var icon: AtlasTexture = null
	match point_type:
		Data.PointType.LOSE: icon = loss_icon
		Data.PointType.WIN: icon = win_icon
		Data.PointType.COLLAB: icon = collab_icon
		Data.PointType.NONE: icon = none_icon
	
	TriggerPointTypeSprite.scale = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(TriggerPointTypeSprite, "scale", Vector2.ONE, trigger_point_type_display_delay)\
		.as_relative().set_trans(Tween.TRANS_SINE)
	TriggerPointTypeSprite.texture = icon
	TriggerPointTypeSprite.visible = true

func onMouseInUI(state: bool) -> void:
	if state: _on_control_mouse_entered()

func setMouseFilter(_mouse_filter: Control.MouseFilter) -> void:
	CardUIButton.setMouseFilter(_mouse_filter)
