class_name StartTurnAction extends Action

var players: bool
func _init(_players: bool) -> void:
	players = _players
	
func onPreAction() -> void: pass
func onPostAction() -> void: pass
func isPlayers() -> bool: return players
func getLogInfo() -> Array:
	return ["Players: %s" % players]
