extends Node

enum PointType {NULL, NONE, LOSE, WIN, COLLAB}
enum CardType {NULL, ANGRY, KIND, SAD, HAPPY, SARCASTIC}
enum Rarity {NULL, ONE, TWO, THREE}

const TURN_TIME: float = 14.0
const MIN_HAND_SIZE: int = 3
const MAX_HAND_SIZE: int = 6
const MAX_DECK_SIZE: int = 10

const DEFAULT_POINT_MOVE: int = 5
const LOSS_POINT_MOVE_MULT: int = 2

const POINTS_TO_WIN: int = 25
const POINTS_TO_COLLABORATE: int = 25
const LOCKED_CARD_TURNS: int = 2

@export var player_deck: Array[DeckCard]
@export var enemy_deck: Array[DeckCard]

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
		CardType.KIND: return Color("1ebc73")
		CardType.SAD: return Color("8fd3ff")
		CardType.HAPPY: return Color("f79617")
		CardType.SARCASTIC: return Color("c32454")
	return Color.WHITE

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
	
