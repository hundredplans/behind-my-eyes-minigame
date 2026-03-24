class_name StartTurnAction extends Action

var players: bool
func _init(_players: bool) -> void:
	players = _players
	
func onPreAction() -> void: pass
func onPostAction() -> void:
	if Board.getCharacter(players).getHandSize() < Data.MIN_HAND_SIZE:
		onPush([DrawCardAction.new(1, players)])
	
func isPlayers() -> bool: return players
func getLogInfo() -> Array:
	return ["Players: %s" % players]
