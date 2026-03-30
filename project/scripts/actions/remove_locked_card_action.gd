class_name RemoveLockedCardAction extends Action

var locked_card: LockedCard
var players: bool
func _init(_locked_card: LockedCard, _players: bool) -> void:
	locked_card = _locked_card
	players = _players

func onPreAction() -> void:
	if locked_card == null or !Board.getCharacter(players).hasLockedCard(locked_card): onFailAction()

func onPostAction() -> void:
	Board.getCharacter(players).onRemoveLockedCard(locked_card)
	onPush([AddDeckCardAction.new(locked_card.getDeckCard(), players)])

func getLogInfo() -> Array:
	return ["Locked Card: %s" % locked_card.getId(), "Players: %s" % players]
