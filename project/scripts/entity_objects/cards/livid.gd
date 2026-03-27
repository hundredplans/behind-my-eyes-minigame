extends Card

const STRONG_STATUS_EFFECT_ID: int = 4
func onTrigger(_enemy_card: Card) -> void:
	onPush([CreateStatusEffectAction.new(Info.getInfo(StatusEffectInfo, STRONG_STATUS_EFFECT_ID),
		Board.getCharacter(isPlayers()))])
