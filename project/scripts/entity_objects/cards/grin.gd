extends Card

const POINTS: int = 4
func onTrigger(_enemy_card: Card) -> void:
	var character: Character = Board.getCharacter(isPlayers())
	var remove_status_effect_actions: Array = character.getStatusEffects()\
		.map(func(x: StatusEffect): return RemoveStatusEffectAction.new(x.getInfo(), character))
	onPush([UpdatePointsAction.new(isPlayers(), POINTS, Data.CardType.SARCASTIC)] + remove_status_effect_actions)
