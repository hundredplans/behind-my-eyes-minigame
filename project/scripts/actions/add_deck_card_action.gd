class_name AddDeckCardAction extends Action

var deck_card: DeckCard
var players: bool
var deck_size: int
var deck_cost: int
func _init(_deck_card: DeckCard, _players: bool) -> void:
	deck_card = _deck_card
	players = _players
	
func onPreAction() -> void:
	if deck_card == null: onFailAction()
	
func onPostAction() -> void:
	Board.getCharacter(players).onAddDeckCard(deck_card)
	
func getLogInfo() -> Array:
	return ["Deck Card: %s" % deck_card.getId(), "Players: %s" % players]
