class_name LockedCard extends Resource

var deck_card: DeckCard
var turns: int

func setInfo(_deck_card: DeckCard) -> void:
	deck_card = _deck_card
	turns = Data.LOCKED_CARD_TURNS
