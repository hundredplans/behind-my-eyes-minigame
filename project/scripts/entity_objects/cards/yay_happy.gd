extends Card

const POINTS: int = -2
func onTrigger(_enemy_card: Card) -> void:
	onPush([UpdatePointsAction.new(isPlayers(), POINTS, Data.CardType.HAPPY),
		UpdatePointsAction.new(!isPlayers(), POINTS, Data.CardType.HAPPY)])
