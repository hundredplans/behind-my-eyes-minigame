class_name DrawCardAction extends Action

var amount: int
var players: bool
func _init(_amount: int, _players: bool) -> void:
	amount = _amount
	players = _players
	
func onPreAction() -> void:
	var deck_cards: Array[DeckCard] = Board.getCharacter(players).getDeckCards()
	var hand_cards: Array[Card] = Board.getCharacter(players).getHandCards()
	if amount <= 0 or deck_cards.is_empty() or hand_cards.size() > Data.MIN_HAND_SIZE or hand_cards.size() == Data.MAX_HAND_SIZE:
		onFailAction()
		
func onPostAction() -> void:
	var deck_cards: Array[DeckCard] = Board.getCharacter(players).getDeckCards()
	var allowed_to_add: int = Data.MAX_HAND_SIZE - Board.getCharacter(players).getHandSize()
	var add_amount: int = min(allowed_to_add, amount)
	
	var actions: Array = []
	for i: int in deck_cards.size():
		if i == amount: break
		var deck_card: DeckCard = deck_cards.pop_back()
		var card: Card = deck_card.getCard(players)
		actions.append(CreateHandCardAction.new(card))
	onPush(actions)
	
func getLogInfo() -> Array:
	return ["Amount: %s" % amount, "Players: %s" % players]
