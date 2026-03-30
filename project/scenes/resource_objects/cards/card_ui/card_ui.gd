class_name CardUI extends Node2D

const DEFAULT_Z: int = 1
const DRAG_Z: int = 80

@onready var CardSprite: Sprite2D = %CardSprite
@onready var atlas = %CardSprite.texture as AtlasTexture
@onready var CardUIButton: DefaultButton = %CardUIButton
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
	DescriptionLabel.text = card.getInfo().getDescription()
	
func onCreateHandCard() -> void: card.remove_hand_card.connect(onRemoveHandCard)
func onRemoveHandCard() -> void: queue_free()
	
func setDisabled(_disabled: bool) -> void: CardUIButton.setDisabled(_disabled)
func getCard() -> Card: return card
