class_name Card extends EntityObject

var players: bool
func _init(_info: CardInfo, _players: bool) -> void:
	super(_info)
	players = _players
	onConnectToActions()

func getCardType() -> Data.CardType: return info.getType()
func isPlayers() -> bool: return players
func getInfo() -> CardInfo: return info
