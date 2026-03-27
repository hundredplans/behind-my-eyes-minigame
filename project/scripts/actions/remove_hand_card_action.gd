class_name RemoveHandCardAction extends Action

var card: Card
var destroy: bool
func _init(_card: Card) -> void:
	card = _card

func onPreAction() -> void: if card == null: onFailAction()
func onPostAction() -> void:
	card.onRemoveHandCard()

func getLogInfo() -> Array: return []
