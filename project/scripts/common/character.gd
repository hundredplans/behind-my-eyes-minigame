class_name Character extends ActionManager
signal update_points

var points: int # 0 = collab, 50 = win
var deck_cards: Array[DeckCard]
var hand_cards: Array[Card]
var players: bool

func setInfo(_deck_cards: Array, _players: bool) -> void:
	deck_cards.assign(_deck_cards)
	deck_cards.shuffle()
	players = _players
	@warning_ignore("integer_division")
	onUpdatePoints((Data.POINTS_TO_WIN + Data.POINTS_TO_COLLABORATE) / 2)
	onConnectToActions()
	
func onProcessAction(action: Action) -> void:
	if action.isPost():
		if action is CreateHandCardAction and action.getCard().isPlayers() == players:
			onCreateHandCard(action)
		elif action is PlayCardAction and action.getCard().isPlayers() == players:
			onPlayCard(action)
			
func isWin() -> bool: return points == Data.POINTS_TO_COLLABORATE + Data.POINTS_TO_WIN
func isCollab() -> bool: return points == 0
			
func onCreateHandCard(action: CreateHandCardAction) -> void:
	hand_cards.append(action.getCard())
	
func onPlayCard(action: PlayCardAction) -> void:
	hand_cards.erase(action.getCard())
	
func onUpdatePoints(delta: int) -> void:
	points += delta
	update_points.emit()
	
func getPoints() -> int: return points
func getDeckCards() -> Array[DeckCard]: return deck_cards
func getHandCards() -> Array[Card]: return hand_cards
func getHandSize() -> int: return hand_cards.size()
func getDeckSize() -> int: return deck_cards.size()
