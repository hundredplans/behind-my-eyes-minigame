extends Card

const CONFIDENT_ID: int = 8
func onTrigger(_enemy_card: Card) -> void:
	onPush([CreateStatusEffectAction.new(\
		Info.getInfo(StatusEffectInfo, CONFIDENT_ID), Board.getCharacter(isPlayers()))])
