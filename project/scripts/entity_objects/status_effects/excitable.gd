extends StatusEffect

const POINTS_BUFF: int = 2
const START_CARDS_REMAINING: int = 3
var cards_remaining: int

func onProcessAction(action: Action) -> void:
	if !action.isPost():
		if action is UpdatePointsAction and action.isCardDefault() and action.isPlayers() == isPlayers():
			onForce([ExcitableTriggerStatusEffectAction.new(self)])

func onStatusEffectCreated() -> void:
	cards_remaining = START_CARDS_REMAINING
	onUpdateDisplayAmount()

func onExcitable(action: UpdatePointsAction) -> void:
	action.onUpdateExtraDelta(POINTS_BUFF)
	cards_remaining -= 1
	onUpdateDisplayAmount()
	
	if cards_remaining <= 0: onPush([RemoveStatusEffectAction.new(info, character)])
	
func getDisplayAmount() -> int: return cards_remaining
