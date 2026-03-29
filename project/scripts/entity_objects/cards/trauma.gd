extends Card

func onTrigger(_enemy_card: Card) -> void:
	var deck_cards: Array = Board.getCharacter(isPlayers()).getDeckCards().filter(func(x: DeckCard):\
		return Info.getInfo(CardInfo, x.getId()).getType() == Data.CardType.SAD)
	if deck_cards.is_empty(): return
	var sad_deck_card: DeckCard = deck_cards.pick_random()
	var sad_card: Card = sad_deck_card.getCard(isPlayers())
	onPush([InsertCardAction.new(sad_card, sad_deck_card, isPlayers())])
