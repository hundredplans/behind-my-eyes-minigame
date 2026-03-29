extends Card

const DEFAULT_POINTS: int = 2
const HAPPY_CARD_POINTS: int = 6
func onTrigger(enemy_card: Card) -> void:
	var points: int = (HAPPY_CARD_POINTS if enemy_card.getCardType() == Data.CardType.HAPPY else DEFAULT_POINTS)
	onPush([UpdatePointsAction.new(isPlayers(), points)])
