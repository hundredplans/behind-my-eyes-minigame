class_name InsertCardAction extends Action

var card: Card
var deck_card: DeckCard
var players: bool
func _init(_card: Card, _deck_card: DeckCard, _players: bool) -> void:
	card = _card
	deck_card = _deck_card
	players = _players
	
func onPreAction() -> void: if card == null: onFailAction()
func onPostAction() -> void:
	if deck_card != null:
		Board.getCharacter(players).getDeckCards().erase(deck_card)
		print("Deck Cards: %s" % Board.getCharacter(players).getDeckCards().size())
	onPush([CreateHandCardAction.new(card)])
	
func getLogInfo() -> Array:
	return ["Card: %s" % card.getName()]
