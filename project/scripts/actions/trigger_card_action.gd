class_name TriggerCardAction extends Action

var card: Card
var enemy_card: Card
func _init(_card: Card, _enemy_card: Card) -> void:
	card = _card
	enemy_card = _enemy_card
	
func onPreAction() -> void:
	if card == null or enemy_card == null: onFailAction()

func onPostAction() -> void:
	card.onTrigger(enemy_card)

func getCard() -> Card: return card
func getEnemyCard() -> Card: return enemy_card
func getLogInfo() -> Array:
	return ["Card: %s" % card.getName(), "Enemy Card: %s" % enemy_card.getName()]
