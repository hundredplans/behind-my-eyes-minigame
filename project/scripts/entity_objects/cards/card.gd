@abstract
class_name Card extends EntityObject

signal remove_hand_card

var players: bool
func _init(_info: CardInfo, _players: bool) -> void:
	super(_info)
	players = _players
	# Not connected to process action because dont need to yet

func getCardType() -> Data.CardType: return info.getType()
func isPlayers() -> bool: return players
func getInfo() -> CardInfo: return info
func onTriggerDefault(enemy_card: Card) -> void:
	onTrigger(enemy_card)
	var point_type: Data.PointType = GameLogic.getMatchType(getCardType(), enemy_card.getCardType())
	var delta: int = Data.DEFAULT_POINT_MOVE
	var _is_players: bool = isPlayers()
	match point_type:
		Data.PointType.NONE: return
		Data.PointType.COLLAB: delta *= -1
		Data.PointType.LOSE:
			delta *= Data.LOSS_POINT_MOVE_MULT
			_is_players = !_is_players
	var update_points_action := UpdatePointsAction.new(_is_players, delta)
	update_points_action.setCardDefault(true)
	var actions: Array = [update_points_action]
	onPush(actions)
	
func onRemoveHandCard() -> void: remove_hand_card.emit()

@abstract func onTrigger(enemy_card: Card) -> void
