class_name RemoveHandCardAction extends Action

var card: Card
var destroy: bool
func _init(_card: Card) -> void:
	card = _card

func onPreAction() -> void: if card == null: onFailAction()
func onPostAction() -> void:
	card.onRemoveHandCard()
	Board.getCharacter(card.isPlayers()).getHandCards().erase(card)

func getLogInfo() -> Array: return []
