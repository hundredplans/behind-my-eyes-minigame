class_name DeckCard extends Resource

@export var id: int
func getCard(players: bool) -> Card:
	var card_info: CardInfo = Info.getInfo(CardInfo, id)
	var card := Card.new(card_info, players)
	return card
