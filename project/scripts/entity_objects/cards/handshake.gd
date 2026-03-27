extends Card

const POINTS: int = -2
func onTrigger(_enemy_card: Card) -> void:
	var handshake: Card = getInfo().getCard(!isPlayers())
	onPush([UpdatePointsAction.new(isPlayers(), POINTS), CreateHandCardAction.new(handshake)])
