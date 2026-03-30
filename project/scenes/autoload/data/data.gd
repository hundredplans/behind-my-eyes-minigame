extends Node

enum PointType {NULL, NONE, LOSE, WIN, COLLAB}
enum CardType {NULL, ANGRY, KIND, SAD, HAPPY, SARCASTIC}
enum Rarity {NULL, ONE, TWO, THREE}

const MIN_HAND_SIZE: int = 3
const MAX_HAND_SIZE: int = 6
const MAX_DECK_SIZE: int = 10

const DEFAULT_POINT_MOVE: int = 5
const LOSS_POINT_MOVE_MULT: int = 2

const POINTS_TO_WIN: int = 25
const POINTS_TO_COLLABORATE: int = 25

@export var player_deck: Array[DeckCard]
@export var enemy_deck: Array[DeckCard]

@export var angry_icon: Texture2D
@export var kind_icon: Texture2D
@export var sad_icon: Texture2D
@export var happy_icon: Texture2D
@export var sarcastic_icon: Texture2D 

func getXFromCardType(card_type: CardType) -> int:
	match card_type:
		CardType.ANGRY: return 208
		CardType.KIND: return 16
		CardType.SAD: return 80
		CardType.HAPPY: return 144
		CardType.SARCASTIC: return 272
	return 0
	
func getYFromCardRarity(rarity) -> int:
	match rarity:
		Rarity.NULL: return 0
		Rarity.ONE: return 208
		Rarity.TWO: return 304
		Rarity.THREE:return 400
	return 0
	
func getColorFromCardType(card_type: CardType) -> Color:
	match card_type:
		CardType.ANGRY: return Color("e83b3b")
		CardType.KIND: return Color("91db69")
		CardType.SAD: return Color("4d9be6")
		CardType.HAPPY: return Color("f9c22b")
		CardType.SARCASTIC: return Color("831c5d")
	return Color.WHITE
	
func getCardTypeIcon(type: Data.CardType) -> Texture2D:
	match type:
		CardType.ANGRY: return angry_icon
		CardType.KIND: return kind_icon
		CardType.SAD: return sad_icon
		CardType.HAPPY: return happy_icon
		CardType.SARCASTIC: return sarcastic_icon
	return null

func getPlayerStartingDeck() -> Array[DeckCard]:
	return getRandomDeck()
	
func getEnemyStartingDeck() -> Array[DeckCard]:
	return getRandomDeck()

func getRandomDeck() -> Array[DeckCard]:
	var deck_cards: Array[DeckCard] = []
	for __: int in MAX_DECK_SIZE:
		var id: int = randi_range(1, 30)
		var deck_card := DeckCard.new()
		deck_card.setId(id)
		deck_cards.append(deck_card)
	return deck_cards
	
static func getPointTypeString(point_type: PointType) -> String:
	match point_type:
		PointType.NONE: return "None"
		PointType.LOSE: return "Lose"
		PointType.WIN: return "Win"
	return ""
	
