extends Card

const POINTS: int = 6
func onTrigger(_enemy_card: Card) -> void:
	onPush([UpdatePointsAction.new(isPlayers(), POINTS, Data.CardType.ANGRY)])
