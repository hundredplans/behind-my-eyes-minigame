extends Card

func onTrigger(_enemy_card: Card) -> void:
	var character: Character = Board.getCharacter(!isPlayers())
	var remove_status_effect_actions: Array = character.getStatusEffects()\
		.map(func(x: StatusEffect): return RemoveStatusEffectAction.new(x.getInfo(), character))
	onPush(remove_status_effect_actions)
