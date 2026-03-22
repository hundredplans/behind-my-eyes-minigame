extends Node

enum PointType {NULL, NONE, LOSE, WIN, COLLAB}
enum CardType {NULL, ANGRY, KIND, SAD, HAPPY, SARCASTIC}
const MIN_HAND_SIZE: int = 3
const MAX_HAND_SIZE: int = 8

const POINTS_TO_WIN: int = 25
const POINTS_TO_COLLABORATE: int = 25

@export var player_deck: Array[DeckCard]
@export var enemy_deck: Array[DeckCard]

func getColorFromCardType(card_type: CardType) -> Color:
	match card_type:
		CardType.ANGRY: return Color.RED
		CardType.KIND: return Color.GREEN
		CardType.SAD: return Color.BLUE
		CardType.HAPPY: return Color.YELLOW
		CardType.SARCASTIC: return Color.PURPLE
	return Color.WHITE

func getPlayerStartingDeck() -> Array[DeckCard]: return player_deck.duplicate()
func getEnemyStartingDeck() -> Array[DeckCard]: return enemy_deck.duplicate()
