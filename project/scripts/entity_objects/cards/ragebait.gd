extends Card

const IRRITABLE_ID: int = 5
const POINTS: int = 6
func onTrigger(_enemy_card: Card) -> void:
	onPush([UpdatePointsAction.new(isPlayers(), POINTS, Data.CardType.ANGRY),
		CreateStatusEffectAction.new(Info.getInfo(StatusEffectInfo, IRRITABLE_ID),
		Board.getCharacter(!isPlayers()))])
	
