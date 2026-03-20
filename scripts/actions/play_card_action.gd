class_name PlayCardAction extends Action

const PLAY_CARD_DELAY: float = 0.5

var card: Card
func _init(_card: Card) -> void:
	card = _card
	
func onPreAction() -> void:
	if card == null: onFailAction()
	
func onPostAction() -> void:
	onPush([DelayAction.new(PLAY_CARD_DELAY)])
	
func getLogInfo() -> Array:
	return ["Card: %s" % card]
