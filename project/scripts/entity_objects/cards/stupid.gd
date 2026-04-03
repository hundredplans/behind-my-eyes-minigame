extends Card

const POINTS: int = -4
func onTrigger(_enemy_card: Card) -> void:
	var enemy: Character = Board.getCharacter(!isPlayers())
	if enemy.getPoints() > Data.POINTS_TO_COLLABORATE:
		var delta: int = min(enemy.getPoints() - Data.POINTS_TO_COLLABORATE, POINTS)
		onPush([UpdatePointsAction.new(!isPlayers(), delta, Data.CardType.ANGRY)])
