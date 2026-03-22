class_name Card extends EntityObject

var players: bool
func _init(_info: CardInfo, _players: bool) -> void:
	super(_info)
	players = _players
	onConnectToActions()

func getCardType() -> Data.CardType: return info.getType()
func isPlayers() -> bool: return players
func getInfo() -> CardInfo: return info
func onTrigger(enemy_card: Card) -> void:
	var point_type: Data.PointType = GameLogic.getMatchType(getCardType(), enemy_card.getCardType())
	var delta: int = Data.DEFAULT_POINT_MOVE
	match point_type:
		Data.PointType.NONE: return
		Data.PointType.LOSE:
			delta *= Data.LOSS_POINT_MOVE_MULT
			Board.getOtherCharacter(players).onUpdatePoints(delta)
		Data.PointType.WIN:
			Board.getCharacter(players).onUpdatePoints(delta)
		Data.PointType.COLLAB:
			Board.getCharacter(players).onUpdatePoints(-delta)
