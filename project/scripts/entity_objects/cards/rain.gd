extends Card

const GRUMPY_ID: int = 6
func onTrigger(_enemy_card: Card) -> void:
	onPush([CreateStatusEffectAction.new(\
	Info.getInfo(StatusEffectInfo, GRUMPY_ID), Board.getCharacter(isPlayers()))])
