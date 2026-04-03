extends Card

const POINTS: int = 4
func onTrigger(_enemy_card: Card) -> void:
	onPush([UpdatePointsAction.new(players, POINTS, Data.CardType.ANGRY)])
