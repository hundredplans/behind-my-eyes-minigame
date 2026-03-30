class_name LockedCard extends Resource

var deck_card: DeckCard
var turns: int

func setInfo(_deck_card: DeckCard) -> void:
	deck_card = _deck_card
	turns = Data.LOCKED_CARD_TURNS

func getDeckCard() -> DeckCard: return deck_card
func getTurns() -> int: return turns
func onDeincrementTurns() -> void: turns -= 1
func getId() -> int: return deck_card.getId()

func isUnlocked() -> bool: return turns == 0
