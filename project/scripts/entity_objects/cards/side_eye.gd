extends Card

const SINCERE_ID: int = 7
func onTrigger(_enemy_card: Card) -> void:
	onPush([CreateStatusEffectAction.new(
		Info.getInfo(StatusEffectInfo, SINCERE_ID), Board.getCharacter(!isPlayers()))])
