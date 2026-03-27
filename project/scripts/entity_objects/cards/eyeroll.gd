extends Card

const DEFAULT_POINTS: int = 4
const NICE_CARD_POINTS: int = 10
func onTrigger(enemy_card: Card) -> void:
	var points: int = (NICE_CARD_POINTS if enemy_card.getCardType() == Data.CardType.KIND else DEFAULT_POINTS)
	onPush([UpdatePointsAction.new(isPlayers(), points)])
