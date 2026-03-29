extends Card

const SUNNY_ID: int = 9
func onTrigger(_enemy_card: Card) -> void:
	onPush([CreateStatusEffectAction.new(
		Info.getInfo(StatusEffectInfo, SUNNY_ID), Board.getCharacter(isPlayers()))])
