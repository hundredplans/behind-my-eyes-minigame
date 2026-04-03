class_name RemoveCardFromDeckAction extends Action

var card: CardUI
func _init(_card: CardUI) -> void:
	card=_card
	
	return
func onPreAction() -> void:
	if card == null or card.inDeck==false: onFailAction()
	
	
func onPostAction() -> void:
	return
	
func getLogInfo() -> Array:
	return []
