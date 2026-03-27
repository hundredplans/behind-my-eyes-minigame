class_name UpdatePointsAction extends Action

var players: bool
var delta: int
func _init(_players: bool, _delta: int) -> void:
	players = _players
	delta = _delta
	
func onPreAction() -> void: pass
func onPostAction() -> void:
	var main_char: Character = Board.getCharacter(players)
	var other_char: Character = Board.getCharacter(!players)
	main_char.onUpdatePoints(delta)
	var end_game_type := EndGameAction.Type.NULL
	if main_char.isWin():
		if players: end_game_type = EndGameAction.Type.WIN
		else: end_game_type = EndGameAction.Type.LOSS
	elif main_char.isCollab() and other_char.isCollab():
		end_game_type = EndGameAction.Type.COLLAB
	onPush([EndGameAction.new(end_game_type)])
	
func getLogInfo() -> Array:
	return ["Players: %s" % players, "Delta: %s" % delta]
	
func isPlayers() -> bool: return players
func getDelta() -> int: return delta
