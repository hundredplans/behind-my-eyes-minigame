extends Card

const POINTS: int = -2
func onTrigger(_enemy_card: Card) -> void:
	onPush([UpdatePointsAction.new(isPlayers(), POINTS),
		UpdatePointsAction.new(!isPlayers(), POINTS)])
