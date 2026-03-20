class_name CreateHandCardAction extends Action

var card: Card
func _init(_card: Card) -> void:
	card = _card
	
func onPreAction() -> void: pass
func onPostAction() -> void: pass
func getCard() -> Card: return card
func getLogInfo() -> Array:
	return ["Card: %s" % card.getName()]
