class_name TriggerCardEffectsAction extends Action

const TRAVEL_DELAY: float = 1.0
const FLASH_DELAY: float = 2.0
var field_cards: Array[Card] = []
func onPreAction() -> void: pass
func onPostAction() -> void:
	var actions: Array = [DelayAction.new(getTotalDelay())]
	field_cards = Board.getFieldCards().duplicate()
	for i: int in field_cards.size():
		var card: Card = field_cards[i]
		var enemy_card: Card = field_cards[abs(i - 1)]
		actions.append(TriggerCardAction.new(card, enemy_card))
	Board.onResetFieldCards()
	onPush(actions)

func getTotalDelay() -> float: return getTravelDelay() + getFlashDelay()
func getTravelDelay() -> float: return TRAVEL_DELAY
func getFlashDelay() -> float: return FLASH_DELAY
func getFieldCards() -> Array[Card]: return field_cards
func getLogInfo() -> Array:
	return []
