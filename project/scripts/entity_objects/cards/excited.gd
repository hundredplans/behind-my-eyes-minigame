extends Card

const EXCITABLE_ID: int = 2
func onTrigger(_enemy_card: Card) -> void:
	onPush([CreateStatusEffectAction.new(Info.getInfo(StatusEffectInfo, EXCITABLE_ID), Board.getCharacter(isPlayers()))])
