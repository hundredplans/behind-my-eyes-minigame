class_name UpdatePointsAction extends Action

var players: bool
var delta: int
var extra_delta: int
var doubled: bool
var nullified: bool
var card_default: int

func _init(_players: bool, _delta: int) -> void:
	players = _players
	delta = _delta
	
func onPreAction() -> void: pass
func onPostAction() -> void:
	var main_char: Character = Board.getCharacter(players)
	var other_char: Character = Board.getCharacter(!players)
	
	var points_delta: int = delta + extra_delta
	if doubled: points_delta *= 2
	if nullified: points_delta = 0
	main_char.onUpdatePoints(points_delta)
	var end_game_type := EndGameAction.Type.NULL
	if main_char.isWin():
		if players: end_game_type = EndGameAction.Type.WIN
		else: end_game_type = EndGameAction.Type.LOSS
	elif main_char.isCollab() and other_char.isCollab():
		end_game_type = EndGameAction.Type.COLLAB
	onPush([EndGameAction.new(end_game_type)])
	
func getLogInfo() -> Array:
	return ["Players: %s" % players, "Delta: %s" % delta]
	
func isCardDefault() -> bool: return card_default
func isPlayers() -> bool: return players
func getDelta() -> int: return delta
func onUpdateExtraDelta(_extra_delta: int) -> void: extra_delta = _extra_delta

func setCardDefault(_card_default: bool) -> void: card_default = _card_default

func onDouble(): doubled = true
func onNullify() -> void: nullified = true
