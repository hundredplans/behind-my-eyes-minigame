class_name TriggerCardEffectsAction extends Action

const TRAVEL_DELAY: float = 0.5
const DESTROY_DELAY: float = 0.75
const END_DELAY: float = 0.25
const FLASH_DELAY: float = 2.0
var field_cards: Array[Card] = []
func onPreAction() -> void: pass
func onPostAction() -> void:
	var actions: Array = [DelayAction.new(getTravelDelay())]
	field_cards = Board.getFieldCards().duplicate()
	for i: int in field_cards.size():
		var card: Card = field_cards[i]
		var enemy_card: Card = field_cards[abs(i - 1)]
		actions.append(TriggerCardAction.new(card, enemy_card))
		actions.append(DelayAction.new(FLASH_DELAY / 2.0))
	
	actions.append(DelayAction.new(getDestroyDelay() + getEndDelay()))
	actions += field_cards.map(func(x: Card): return DestroyEntityObjectAction.new(x))
	Board.onResetFieldCards()
	onPush(actions)

func getTotalDelay() -> float: return getTravelDelay() + getFlashDelay() + getDestroyDelay() + getEndDelay()
func getDestroyDelay() -> float: return DESTROY_DELAY
func getTravelDelay() -> float: return TRAVEL_DELAY
func getEndDelay() -> float: return END_DELAY
func getFlashDelay() -> float: return FLASH_DELAY
func getFieldCards() -> Array[Card]: return field_cards
func getLogInfo() -> Array:
	return []
