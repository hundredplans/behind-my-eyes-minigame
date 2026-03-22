class_name TriggerCardEffectsAction extends Action

func onPreAction() -> void: pass
func onPostAction() -> void:
	var actions: Array = []
	var field_cards: Array[Card] = Board.getFieldCards()
	for i: int in field_cards.size():
		var card: Card = field_cards[i]
		var enemy_card: Card = field_cards[abs(i - 1)]
		actions.append(TriggerCardAction.new(card, enemy_card))
	Board.onResetFieldCards()
	onPush(actions)
	
func getLogInfo() -> Array:
	return []
