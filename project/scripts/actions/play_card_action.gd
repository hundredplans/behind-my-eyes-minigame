class_name PlayCardAction extends Action

const PLAYER_PLAY_CARD_DELAY: float = 0.5
const ENEMY_PLAY_CARD_DELAY: float = 2.5

var card: Card
func _init(_card: Card) -> void:
	card = _card
	
func onPreAction() -> void:
	if card == null: onFailAction()
	
func onPostAction() -> void:
	Board.onAppendFieldCard(card)
	var delay: float = PLAYER_PLAY_CARD_DELAY if card.isPlayers() else ENEMY_PLAY_CARD_DELAY
	onPush([RemoveHandCardAction.new(card), CreateLockedCardAction.new(card), DelayAction.new(delay)])
	
func getEnemyPlayCardDelay() -> float: return ENEMY_PLAY_CARD_DELAY
func getCard() -> Card: return card
func getLogInfo() -> Array:
	return ["Card: %s" % card]
