extends Card

const POINTS: int = 8
func onTrigger(_enemy_card: Card) -> void:
	var points: int = Board.getCharacter(isPlayers()).getPoints()
	var enemy_points: int = Board.getCharacter(!isPlayers()).getPoints()
	var direction: int = 1 if points < enemy_points else -1
	onPush([UpdatePointsAction.new(isPlayers(), points * direction, Data.CardType.SAD)])
