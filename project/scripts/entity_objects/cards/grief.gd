extends Card

const SENTIMENTAL_STATUS_EFFECT_ID: int = 3
func onTrigger(_enemy_card: Card) -> void:
	onPush([CreateStatusEffectAction.new(Info.getInfo(StatusEffectInfo, SENTIMENTAL_STATUS_EFFECT_ID),
		Board.getCharacter(!isPlayers()))])
