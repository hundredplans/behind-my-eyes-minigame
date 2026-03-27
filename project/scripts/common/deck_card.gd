class_name DeckCard extends Resource

@export var id: int
func setId(_id: int) -> void:
	id = _id

func getCard(players: bool) -> Card:
	var card_info: CardInfo = Info.getInfo(CardInfo, id)
	var card: Card = card_info.getCard(players)
	return card
