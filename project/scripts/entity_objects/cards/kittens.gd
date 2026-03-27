extends Card

func onTrigger(_enemy_card: Card) -> void:
	var hand_cards: Array = Board.getCharacter(isPlayers()).getHandCards()
	var actions: Array = []
	var amount: int = hand_cards.size()
	for hand_card: Card in hand_cards:
		actions.append(RemoveHandCardAction.new(hand_card))
		actions.append(DestroyEntityObjectAction.new(hand_card))
	
	var happy_cards: Array[Card] = getRandomHappyCards(amount)
	actions += Array(happy_cards).map(func(x: Card): return CreateHandCardAction.new(x))
	onPush(actions)

func getRandomHappyCards(amount: int) -> Array[Card]:
	var happy_cards: Array[Card] = []
	var happy_card_infos: Array = Info.getInfos(CardInfo).filter(func(x: CardInfo):\
		return x.getType() == Data.CardType.HAPPY)
	
	assert(!happy_card_infos.is_empty(), "No happy cards exist?")
	for __: int in amount:
		var happy_card_info: CardInfo = happy_card_infos.pick_random()
		happy_cards.append(happy_card_info.getCard(isPlayers()))
	return happy_cards
