extends StatusEffect

const POINTS: int = -1
func onProcessAction(action: Action) -> void:
	if !action.isPost():
		if action is UpdatePointsAction and action.isCollab() and action.isPlayers() == isPlayers():
			onForce([SunnyTriggerStatusEffectAction.new(self, action)])

func onSunny(action: UpdatePointsAction) -> void:
	action.onUpdateExtraDelta(POINTS)
