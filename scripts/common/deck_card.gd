class_name DeckCard extends Resource

@export var id: int
func getCard() -> Card:
	var card_info: CardInfo = Info.getInfo(CardInfo, id)
	var card := Card.new(card_info)
	return card
