class_name PlayCardAction extends Action

const PLAY_CARD_DELAY: float = 0.5

var card: Card
var card_ui: CardUI
func _init(_card: Card, _card_ui: CardUI) -> void:
	card = _card
	card_ui = _card_ui
	
func onPreAction() -> void: pass
func onPostAction() -> void:
	if card_ui != null: card_ui.queue_free()
	onPush([DelayAction.new(PLAY_CARD_DELAY)])
	
func getCard() -> Card: return card
func getLogInfo() -> Array:
	return ["Card: %s" % card]
