class_name CreateLockedCardAction extends Action

var card: Card
func _init(_card: Card) -> void:
	card = _card
	
func onPreAction() -> void: if card == null: onFailAction()
func onPostAction() -> void:
	var deck_card := DeckCard.new()
	deck_card.setId(card.getInfo().getId())
	
	var locked_card := LockedCard.new()
	locked_card.setInfo(deck_card)
	
	var character: Character = Board.getCharacter(card.isPlayers())
	character.onCreateLockedCard(locked_card)
	
func getLogInfo() -> Array: return ["Card: %s" % card.getName()]
