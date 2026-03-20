class_name Character extends ActionManager

var points: int
var deck_cards: Array[DeckCard]
var hand_cards: Array[Card]
var players: bool

func setInfo(_deck_cards: Array, _players: bool) -> void:
	deck_cards.assign(_deck_cards)
	deck_cards.shuffle()
	players = _players
	
func onProcessAction(action: Action) -> void:
	if action.isPost():
		if action is CreateHandCardAction and action.getCard().isPlayers() == players:
			onCreateHandCard(action)
			
func onCreateHandCard(action: CreateHandCardAction) -> void:
	hand_cards.append(action.getCard())
	
func getPoints() -> int: return points
func getDeckCards() -> Array[DeckCard]: return deck_cards
func getHandCards() -> Array[Card]: return hand_cards
func getHandSize() -> int: return hand_cards.size()
func getDeckSize() -> int: return deck_cards.size()
