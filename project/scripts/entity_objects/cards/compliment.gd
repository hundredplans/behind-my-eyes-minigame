extends Card

const HAPPY_STATUS_EFFECT_ID: int = 1
func onTrigger(_enemy_card: Card) -> void:
	onPush([CreateStatusEffectAction.new(Info.getInfo(StatusEffectInfo, HAPPY_STATUS_EFFECT_ID),
		Board.getCharacter(!isPlayers()))])
