class_name UpdatePointsAction extends Action

var point_type: Data.PointType
var players: bool
var delta: int
func _init(_point_type: Data.PointType, _players: bool, _delta: int) -> void:
	point_type = _point_type
	players = _players
	delta = _delta
	
func onPreAction() -> void: pass
func onPostAction() -> void:
	Board.getCharacter(players).onUpdatePoints(point_type, delta)
	
func getLogInfo() -> Array:
	return ["Point Type: %s" % Data.getPointTypeString(point_type), "Players: %s" % players, "Delta: %s" % delta]

func getPointType() -> Data.PointType: return point_type
func isPlayers() -> bool: return players
func getDelta() -> int: return delta
