class_name PutCardInDeckAction extends Action

var card: CardUI
var cost: int
var currentDeckSize: int
func _init(_card: CardUI, _cost: int, _currentDeckSize: int) -> void:
	cost=_cost
	card=_card
	currentDeckSize=_currentDeckSize
	
func onPreAction() -> void:
	if card == null or card.inDeck==true or cost+card.card.getInfo().rarity > 20 or currentDeckSize>=10 : onFailAction()
	
func onPostAction() -> void:
	return
	
func getLogInfo() -> Array:
	return []
